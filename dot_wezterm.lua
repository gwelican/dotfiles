-- Pull in the wezterm API
-- 
-- vim: tabstop=2 shiftwidth=2 expandtab smarttab

local wezterm = require("wezterm")
local action = wezterm.action

wezterm.on("update-right-status", function(window, pane)
  -- "Wed Mar 3 08:14"
  local date = wezterm.strftime("%a %b %-d %H:%M ")

  local bat = ""
  for _, b in ipairs(wezterm.battery_info()) do
    bat = "🔋 " .. string.format("%.0f%%", b.state_of_charge * 100)
  end

  window:set_right_status(wezterm.format({
    { Text = bat .. "   " .. date },
  }))
end)

local config = wezterm.config_builder()
config.color_scheme = "Catppuccino Mocha"
-- config.window_background_image = "/Users/pvarsanyi/Downloads/background.jpeg"
local act = wezterm.action

config.leader = { key = 'z', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- Quick select mode 
  { key = 'Space', mods = 'LEADER', action = action.QuickSelect },
  {
    key = 'c',
    mods = 'SUPER',
    action = wezterm.action_callback(function(window, pane)
      -- Copy and clear selection
      window:perform_action(action.CopyTo 'ClipboardAndPrimarySelection', pane)
      window:perform_action(action.ClearSelection, pane)
    end),
  },
  { -- Paste
    key = 'p',
    mods = 'SUPER',
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ''
      if has_selection then
        -- Paste and clear selection
        window:perform_action(action.PasteFrom 'PrimarySelection', pane)
        window:perform_action(action.ClearSelection, pane)
      else
        -- Paste from clipboard instead
        window:perform_action(action.PasteFrom 'Clipboard', pane)
      end
    end),
  },

  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") },
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },
  { key = "RightArrow", mods = "CMD", action = act.ActivateTabRelative(1) },
  { key = "LeftArrow", mods = "CMD", action = act.ActivateTabRelative(-1) },
    { -- Launcher
    key = 't',
    mods = 'SUPER|SHIFT',
    action = action.ShowLauncher,
  },
}
config.font_size = 16.0
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30
config.enable_scroll_bar = true
config.window_decorations = "RESIZE"

function make_mouse_binding(dir, streak, button, mods, action)
  return {
    event = { [dir] = { streak = streak, button = button } },
    mods = mods,
    action = action,
  }
end
-- config.mouse_bindings = {
--   {
--     event = { Up = { streak = 1, button = "Left" } },
--     mods = "CMD",
--     action = act.OpenLinkAtMouseCursor,
--   },
--   -- {
--   --   event = { Up = { streak = 2, button = "Left" } },
--   --   mods = "CMD",
--   --   action = act.SelectTextAtMouseCursor("word"),
--   -- },
--   -- {
--   --   event = { Up = { streak = 2, button = "Left" } },
--   --   mods = "ALT",
--   --   action = act.SelectTextAtMouseCursor("word"),
--   -- },
--   make_mouse_binding(
--     "Up",
--     1,
--     "Left",
--     "NONE",
--     wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
--   ),
--   make_mouse_binding(
--     "Up",
--     1,
--     "Left",
--     "SHIFT",
--     wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
--   ),
--   make_mouse_binding("Up", 1, "Left", "ALT", wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")),
--   make_mouse_binding(
--     "Up",
--     1,
--     "Left",
--     "SHIFT|ALT",
--     wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
--   ),
--   make_mouse_binding("Up", 2, "Left", "NONE", wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")),
--   make_mouse_binding("Up", 3, "Left", "NONE", wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")),
-- }

config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make task numbers clickable
-- the first matched regex group is captured in $1.
table.insert(config.hyperlink_rules, {
  regex = [[\broot_span_id: (\d+)\b]],
  format = "https://app.datadoghq.com/apm/trace/$1",
})
return config
