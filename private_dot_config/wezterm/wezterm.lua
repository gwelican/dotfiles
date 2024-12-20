-- Pull in the wezterm API
-- 
-- vim: tabstop=2 shiftwidth=2 expandtab smarttab
local colors = require 'helpers/colors'

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
-- config.color_scheme = "Catppuccino Mocha"
config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = colors.colors.active_tab.bg,
      fg_color = colors.colors.active_tab.fg,
      intensity = 'Normal',
    },

    inactive_tab = {
      bg_color = colors.colors.inactive_tab.bg,
      fg_color = colors.colors.inactive_tab.fg,
    },

    inactive_tab_hover = {
      bg_color = colors.colors.inactive_tab_hover.bg,
      fg_color = colors.colors.inactive_tab_hover.fg,
    },

    new_tab = {
      bg_color = colors.colors.new_tab.bg,
      fg_color = colors.colors.new_tab.fg,
    },

    new_tab_hover = {
      bg_color = colors.colors.new_tab_hover.bg,
      fg_color = colors.colors.new_tab_hover.fg,
    },
  },
}

config.window_background_image = "/Users/pvarsanyi/.config/wezterm/background.jpg"


config.window_background_image_hsb = {
  brightness = 0.2,
  saturation = 1.0,
  hue = 1.0,
}

config.leader = { key = 'x', mods = 'CTRL', timeout_milliseconds = 987 }

config.keys = {
  -- Quick select mode 
  { key = 'Space', mods = 'LEADER', action = action.QuickSelect },
  -- Copy and clear
  {
    key = 'c',
    mods = 'SUPER',
    action = wezterm.action_callback(function(window, pane)
      -- Copy and clear selection
      window:perform_action(action.CopyTo 'ClipboardAndPrimarySelection', pane)
      window:perform_action(action.ClearSelection, pane)
    end),
  },
  -- Paste and clear
  {
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

  { -- Preferences
    key = ',',
    mods = 'SUPER',
    action = action.SpawnCommandInNewTab {
      cwd = wezterm.home_dir,
      args = { 'code', wezterm.config_dir },
    },
  },
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = "LeftArrow", mods = "OPT", action = action.SendString("\x1bb") },
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = "RightArrow", mods = "OPT", action = action.SendString("\x1bf") },
  { key = "RightArrow", mods = "CMD", action = action.ActivateTabRelative(1) },
  { key = "LeftArrow", mods = "CMD", action = action.ActivateTabRelative(-1) },
    -- Launcher
  { key = 't', mods = 'SUPER|SHIFT', action = action.ShowLauncher, },
}
config.font_size = 16.0
config.enable_scroll_bar = true
config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.2
-- config.macos_window_background_blur = 30

function make_mouse_binding(dir, streak, button, mods, action)
  return {
    event = { [dir] = { streak = streak, button = button } },
    mods = mods,
    action = action,
  }
end

config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make task numbers clickable
-- the first matched regex group is captured in $1.
table.insert(config.hyperlink_rules, {
  regex = [[\broot_span_id: (\d+)\b]],
  format = "https://app.datadoghq.com/apm/trace/$1",
})
return config
