import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname } from "node:path";

import type {
  ExtensionAPI,
  ExtensionContext,
  InputEvent,
  ToolInfo,
} from "@earendil-works/pi-coding-agent";

type RouteRule = {
  name: string;
  description: string;
  match: RegExp[];
  tools: RegExp[];
  skills?: string[];
};

type SavedRulesFile = {
  version: 1;
  rules: Record<string, string[]>;
};

type RouteMatch = {
  rule: RouteRule;
  tools: string[];
  skills: string[];
};

const RULES: RouteRule[] = [
  {
    name: "observability",
    description: "Grafana, Prometheus, Loki, Tempo, alerts, logs, metrics, dashboards, Flux health.",
    match: [
      /\b(observability|grafana|prometheus|promql|loki|tempo|dashboard|panel|alert|on-?call|incident|metric|logs?|traces?|slo|datasource|flux|reconcile|kustomization|helmrelease)\b/i,
    ],
    tools: [/^mcp__.*(?:toolhive[-_]observability|grafana|prometheus|loki|tempo|flux).*$/i],
  },
  {
    name: "media",
    description: "Radarr, Sonarr, Prowlarr, Jellyfin, movies, TV, subtitles, playlists.",
    match: [
      /\b(media|movie|movies|film|tv|series|episode|season|radarr|sonarr|prowlarr|jellyfin|subtitle|playlist|watch|library|download queue|indexer)\b/i,
    ],
    tools: [/^mcp__.*(?:toolhive[-_]media|arr|radarr|sonarr|prowlarr|jellyfin).*$/i],
  },
  {
    name: "home",
    description: "Home Assistant, Homebox inventory, Hydrawise irrigation, entities, automations.",
    match: [
      /\b(home assistant|homeassistant|\bha\b|entity|entities|automation|scene|script|light|sensor|switch|climate|cover|lock|camera|homebox|inventory|location|label|hydrawise|irrigation|sprinkler|watering)\b/i,
    ],
    tools: [/^mcp__.*(?:toolhive[-_]home|ha[-_]mcp|homeassistant|homebox|hydrawise).*$/i],
  },
  {
    name: "creative",
    description: "ComfyUI, Godot, image/video/audio generation, LoRA, workflows, renders.",
    match: [
      /\b(comfyui|comfy|godot|render|workflow|generate (?:an? )?(?:image|video|audio|3d)|image generation|video generation|upscale|lora|checkpoint|controlnet|ip-adapter|sampler|vae|model weights?)\b/i,
    ],
    tools: [/^mcp__.*(?:toolhive[-_]creative|comfyui|godot).*$/i],
  },
  {
    name: "finance",
    description: "Ghostfolio portfolio, holdings, dividends, orders, watchlists, market data.",
    match: [
      /\b(finance|portfolio|holding|holdings|position|positions|stock|stocks|ticker|watchlist|dividend|investment|investments|order|orders|market data|ghostfolio|benchmark|asset profile)\b/i,
    ],
    tools: [/^mcp__.*(?:toolhive[-_]finance|ghostfolio).*$/i],
  },
  {
    name: "tasks",
    description: "Vikunja tasks, projects, labels, comments, task management.",
    match: [
      /\b(vikunja|\bvik\b|task list|todo list|todos?|project task|project tasks|label task|task comment|complete task|reopen task)\b/i,
    ],
    tools: [/^mcp__.*(?:toolhive[-_]tasks|vikunja|\bvik[-_]).*$/i],
  },
  {
    name: "browser-skill",
    description: "Browser automation skill for screenshots, websites, forms, clicks, and login flows.",
    match: [
      /\b(browser|website|web app|screenshot|click(?: a)? button|fill (?:out )?(?:a )?form|login|log in|navigate to|open (?:a )?(?:site|website|page))\b/i,
    ],
    tools: [],
    skills: ["agent-browser"],
  },
  {
    name: "debug-skill",
    description: "Bug diagnosis skill for broken, failing, crashing, slow, flaky, or regressed behavior.",
    match: [
      /\b(debug|diagnose|broken|failing|failure|crash|crashing|exception|traceback|regression|flaky|timeout|slowdown|unexpected behavior)\b/i,
    ],
    tools: [],
    skills: ["diagnosing-bugs"],
  },
  {
    name: "tdd-skill",
    description: "TDD skill for explicit red-green-refactor or test-first requests.",
    match: [/\b(tdd|test[- ]first|red[- ]green[- ]refactor)\b/i],
    tools: [],
    skills: ["tdd"],
  },
  {
    name: "research-skill",
    description: "Research skill for source-backed reading and Markdown findings.",
    match: [/\b(research|source-backed|primary sources|gather (?:docs|sources)|investigate (?:docs|api|library))\b/i],
    tools: [],
    skills: ["research"],
  },
  {
    name: "design-skill",
    description: "Deep module design skill for interfaces, seams, and maintainability.",
    match: [/\b(module design|interface design|deep module|codebase design|where (?:the )?seam goes|make .*testable)\b/i],
    tools: [],
    skills: ["codebase-design"],
  },
];

const ROUTER_TAG = "[autorouter]";
const SAVED_RULES_PATH =
  process.env.OMP_AUTOROUTER_RULES ?? `${process.env.HOME ?? "."}/.omp/agent/autorouter-rules.json`;

let baselineTools: string[] | undefined;
let lastRoute: string | undefined;
let savedRules = loadSavedRules();

function hasToolName(value: unknown): value is ToolInfo {
  return typeof value === "object" && value !== null && "name" in value && typeof value.name === "string";
}

function normalizeKeyword(value: string): string {
  return value.trim().replace(/\s+/g, " ").toLowerCase();
}

function normalizeCategory(value: string): string | undefined {
  const normalized = value.trim().toLowerCase().replace(/[\s_]+/g, "-");
  if (!/^[a-z0-9][a-z0-9-]*$/.test(normalized)) {
    return undefined;
  }

  return normalized;
}


function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function keywordPattern(keyword: string): RegExp {
  const source = escapeRegExp(keyword).replace(/\s+/g, "\\s+");
  return new RegExp(`\\b${source}\\b`, "i");
}

function rulesRecord(value: unknown): Record<string, unknown> | undefined {
  if (typeof value !== "object" || value === null || !("rules" in value)) {
    return undefined;
  }

  const rules = Reflect.get(value, "rules");
  if (typeof rules !== "object" || rules === null) {
    return undefined;
  }

  return rules as Record<string, unknown>;
}


function isSavedRulesFile(value: unknown): value is SavedRulesFile {
  const rules = rulesRecord(value);
  return (
    rules !== undefined &&
    Object.values(rules).every(
      (keywords) => Array.isArray(keywords) && keywords.every((keyword) => typeof keyword === "string"),
    )
  );
}

function loadSavedRules(): Record<string, string[]> {
  if (!existsSync(SAVED_RULES_PATH)) {
    return {};
  }

  try {
    const parsed = JSON.parse(readFileSync(SAVED_RULES_PATH, "utf8")) as unknown;
    if (!isSavedRulesFile(parsed)) {
      return {};
    }

    const loaded: Record<string, string[]> = {};
    for (const [rule, keywords] of Object.entries(parsed.rules)) {
      const category = normalizeCategory(rule);
      if (!category) {
        continue;
      }

      loaded[category] = [...new Set([...(loaded[category] ?? []), ...keywords.map(normalizeKeyword).filter(Boolean)])].sort();
    }

    return loaded;
  } catch {
    return {};
  }
}

function saveSavedRules(): void {
  mkdirSync(dirname(SAVED_RULES_PATH), { recursive: true });
  writeFileSync(
    SAVED_RULES_PATH,
    `${JSON.stringify({ version: 1, rules: savedRules } satisfies SavedRulesFile, null, 2)}\n`,
  );
}

function knownRule(name: string): RouteRule | undefined {
  return RULES.find((rule) => rule.name === name);
}

function categoryToolPattern(category: string): RegExp {
  const categorySource = escapeRegExp(category).replace(/-/g, "[-_]");
  return new RegExp(`^mcp__.*toolhive[-_]${categorySource}(?:[-_].*)?$`, "i");
}

function customRule(name: string, keywords: string[]): RouteRule {
  return {
    name,
    description: `Custom ToolHive category ${name}.`,
    match: keywords.map(keywordPattern),
    tools: [categoryToolPattern(name)],
  };
}

function activeRules(): RouteRule[] {
  const builtInNames = new Set(RULES.map((rule) => rule.name));
  const builtIns = RULES.map((rule) => ({
    ...rule,
    match: [...rule.match, ...(savedRules[rule.name] ?? []).map(keywordPattern)],
  }));
  const customs = Object.entries(savedRules)
    .filter(([rule, keywords]) => !builtInNames.has(rule) && keywords.length > 0)
    .map(([rule, keywords]) => customRule(rule, keywords));

  return [...builtIns, ...customs];
}

function formatSavedRules(): string {
  const entries = Object.entries(savedRules)
    .filter(([, keywords]) => keywords.length > 0)
    .sort(([left], [right]) => left.localeCompare(right));
  if (entries.length === 0) {
    return "none";
  }

  return entries.map(([rule, keywords]) => `${rule}=[${keywords.join(", ")}]`).join("; ");
}

function formatPattern(pattern: RegExp): string {
  return `/${pattern.source}/${pattern.flags}`;
}

function formatRuleList(): string {
  const builtInNames = new Set(RULES.map((rule) => rule.name));
  const builtIns = RULES.map((rule) => {
    const saved = savedRules[rule.name]?.length ? `; saved=[${savedRules[rule.name].join(", ")}]` : "";
    return `${rule.name}: built-in=[${rule.match.map(formatPattern).join(", ")}]${saved}`;
  });
  const customs = Object.entries(savedRules)
    .filter(([rule, keywords]) => !builtInNames.has(rule) && keywords.length > 0)
    .sort(([left], [right]) => left.localeCompare(right))
    .map(([rule, keywords]) => `${rule}: saved=[${keywords.join(", ")}] -> toolhive-${rule}`);

  return [...builtIns, ...customs].join("\n");
}


function collectMatches(pi: ExtensionAPI, text: string): RouteMatch[] {
  const tools = pi.getAllTools().filter(hasToolName);
  const configuredSkills = new Set(
    pi
      .getCommands()
      .filter(
        (command): command is { name: string } =>
          typeof command === "object" &&
          command !== null &&
          "name" in command &&
          typeof command.name === "string" &&
          command.name.startsWith("skill:"),
      )
      .map((command) => command.name.slice("skill:".length)),
  );

  return activeRules()
    .filter((rule) => rule.match.some((pattern) => pattern.test(text)))
    .map((rule) => ({
      rule,
      tools: tools
        .filter((tool) => rule.tools.some((pattern) => pattern.test(tool.name)))
        .map((tool) => tool.name),
      skills: (rule.skills ?? []).filter((skill) => configuredSkills.has(skill)),
    }));
}

function enableMatchedTools(pi: ExtensionAPI, matches: RouteMatch[]): string[] {
  const active = new Set(pi.getActiveTools());
  const added: string[] = [];

  for (const match of matches) {
    for (const tool of match.tools) {
      if (!active.has(tool)) {
        active.add(tool);
        added.push(tool);
      }
    }
  }

  if (added.length > 0) {
    pi.setActiveTools([...active]);
  }

  return added;
}

function firstSkillToInject(matches: RouteMatch[], originalText: string): string | undefined {
  if (/^\s*\/skill:/i.test(originalText)) {
    return undefined;
  }

  for (const match of matches) {
    const [skill] = match.skills;
    if (skill) {
      return skill;
    }
  }

  return undefined;
}

function formatMatchSummary(matches: RouteMatch[], addedTools: string[], skill: string | undefined): string {
  const ruleNames = matches.map((match) => match.rule.name).join(", ");
  const pieces = [`rules=${ruleNames}`];

  if (addedTools.length > 0) {
    pieces.push(`enabledTools=${addedTools.length}`);
  }
  if (skill) {
    pieces.push(`skill=${skill}`);
  }

  return pieces.join(" ");
}

function routeText(pi: ExtensionAPI, ctx: ExtensionContext, text: string): string | undefined {
  const matches = collectMatches(pi, text);
  const addedTools = enableMatchedTools(pi, matches);
  const skill = firstSkillToInject(matches, text);

  if (matches.length > 0) {
    lastRoute = formatMatchSummary(matches, addedTools, skill);
    if (ctx.hasUI && (addedTools.length > 0 || skill)) {
      ctx.ui.notify(`${ROUTER_TAG} ${lastRoute}`);
    }
  }

  return skill;
}

export default function mcpSkillAutorouter(pi: ExtensionAPI): void {
  pi.on("session_start", () => {
    baselineTools = pi.getActiveTools();
    lastRoute = undefined;
  });

  pi.on("input", (event: InputEvent, ctx: ExtensionContext) => {
    if (event.source === "extension") {
      return { action: "continue" };
    }

    const text = event.text.trim();
    if (!text || text.startsWith("/")) {
      return { action: "continue" };
    }

    const skill = routeText(pi, ctx, event.text);
    if (!skill) {
      return { action: "continue" };
    }

    return {
      action: "transform",
      text: `/skill:${skill} ${event.text}`,
      images: event.images,
    };
  });

  pi.registerCommand("autorouter", {
    description: "Inspect, reset, or persist automatic MCP/skill routing keywords.",
    getArgumentCompletions: (prefix: string) => {
      return ["status", "rules", "list", "saved", "reset", "test ", "add ", "remove "]
        .filter((value) => value.startsWith(prefix))
        .map((value) => ({ value, label: value }));
    },
    handler: async (args: string, ctx) => {
      const [action = "status", ...rest] = args.trim().split(/\s+/).filter(Boolean);

      if (action === "reset") {
        const next = baselineTools ?? pi.getActiveTools().filter((name) => typeof name === "string" && !name.startsWith("mcp__"));
        pi.setActiveTools(next);
        if (ctx.hasUI) {
          ctx.ui.notify(`${ROUTER_TAG} reset active tools to ${next.length} baseline tools`);
        }
        return;
      }

      if (action === "rules") {
        if (ctx.hasUI) {
          const builtIns = RULES.map((rule) => `${rule.name}${savedRules[rule.name]?.length ? `(+${savedRules[rule.name].length})` : ""}`);
          const builtInNames = new Set(RULES.map((rule) => rule.name));
          const customs = Object.entries(savedRules)
            .filter(([rule, keywords]) => !builtInNames.has(rule) && keywords.length > 0)
            .sort(([left], [right]) => left.localeCompare(right))
            .map(([rule, keywords]) => `${rule}(custom+${keywords.length})`);
          ctx.ui.notify(`${ROUTER_TAG} rules: ${[...builtIns, ...customs].join(", ")}`);
        }
        return;
      }

      if (action === "list") {
        if (ctx.hasUI) {
          ctx.ui.notify(`${ROUTER_TAG} categories:\n${formatRuleList()}`);
        }
        return;
      }

      if (action === "saved") {
        if (ctx.hasUI) {
          ctx.ui.notify(`${ROUTER_TAG} saved: ${formatSavedRules()}`);
        }
        return;
      }

      if (action === "add" || action === "remove") {
        const [rawCategory, ...keywordParts] = rest;
        const category = normalizeCategory(rawCategory ?? "");
        const keyword = normalizeKeyword(keywordParts.join(" "));
        if (!category || !keyword) {
          if (ctx.hasUI) {
            ctx.ui.notify(`${ROUTER_TAG} usage: /autorouter ${action} <category> <keyword>`, "warning");
          }
          return;
        }

        const keywords = savedRules[category] ?? [];
        if (action === "add") {
          savedRules = { ...savedRules, [category]: [...new Set([...keywords, keyword])].sort() };
          saveSavedRules();
          if (ctx.hasUI) {
            const target = knownRule(category) ? category : `toolhive-${category}`;
            ctx.ui.notify(`${ROUTER_TAG} saved keyword '${keyword}' for ${target}`);
          }
          return;
        }

        const nextKeywords = keywords.filter((savedKeyword) => savedKeyword !== keyword);
        savedRules = { ...savedRules, [category]: nextKeywords };
        if (nextKeywords.length === 0) {
          const { [category]: _removed, ...remainingRules } = savedRules;
          savedRules = remainingRules;
        }
        saveSavedRules();
        if (ctx.hasUI) {
          ctx.ui.notify(`${ROUTER_TAG} removed keyword '${keyword}' from ${category}`);
        }
        return;
      }

      if (action === "test") {
        const probe = rest.join(" ");
        if (!probe) {
          if (ctx.hasUI) {
            ctx.ui.notify(`${ROUTER_TAG} usage: /autorouter test <text>`, "warning");
          }
          return;
        }

        const matches = collectMatches(pi, probe);
        const skill = firstSkillToInject(matches, probe);
        const toolCount = matches.reduce((count, match) => count + match.tools.length, 0);
        if (ctx.hasUI) {
          ctx.ui.notify(
            `${ROUTER_TAG} test rules=${matches.map((match) => match.rule.name).join(",") || "none"} tools=${toolCount} skill=${skill ?? "none"}`,
          );
        }
        return;
      }

      const allTools = pi.getAllTools().filter(hasToolName);
      const activeTools = new Set(pi.getActiveTools().filter((name) => typeof name === "string"));
      const mcpTools = allTools.filter((tool) => tool.name.startsWith("mcp__"));
      const activeMcpTools = mcpTools.filter((tool) => activeTools.has(tool.name));
      if (ctx.hasUI) {
        ctx.ui.notify(
          `${ROUTER_TAG} active=${activeTools.size}/${allTools.length} activeMcp=${activeMcpTools.length}/${mcpTools.length} last=${lastRoute ?? "none"}`,
        );
      }
    },
  });
}
