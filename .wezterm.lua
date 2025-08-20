-- Load wezterm API
local wezterm = require("wezterm")

-- Update the right status bar (shown in tab bar) with the current time
wezterm.on("update-right-status", function(window, pane)
	local time = wezterm.strftime("%I:%M %p") -- 12-hour format with AM/PM
	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#ff6b6b" } }, -- Red color for time
		{ Text = time .. " " },
	}))
end)

-- Main configuration table
return {
	-- Choose a color scheme (uncomment one to use it)
	-- color_scheme = "Catppuccin Mocha",
	-- color_scheme = "Tomorrow Night",
	-- color_scheme = "Gruvbox Dark (Gogh)",
	color_scheme = "GruvboxDarkHard",
	-- color_scheme = "Dracula",
	-- color_scheme = "Tokyo Night Storm",

	-- Cursor appearance settings
	animation_fps = 60, -- Smooth cursor animation
	cursor_blink_ease_in = "EaseOut",
	cursor_blink_ease_out = "EaseOut",
	-- default_cursor_style = "SteadyBar",
	default_cursor_style = "SteadyBlock",
	-- default_cursor_style = "BlinkingBlock",
	cursor_blink_rate = 650,

	-- Font settings
	font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" }),
	font_size = 12.0,

	-- Tab bar behavior and appearance
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	tab_max_width = 16,
	show_tab_index_in_tab_bar = true,
	tab_bar_at_bottom = true,
	show_new_tab_button_in_tab_bar = false,

	-- Window appearance
	window_decorations = "RESIZE", -- Only border, no title bar

	-- Optional: Window padding for better spacing (currently commented out)
	-- window_padding = {
	--   left = 4,
	--   right = 4,
	--   top = 2,
	--   bottom = 2,
	-- },

	-- Custom red-themed tab bar colors
	colors = {
		tab_bar = {
			background = "#1a0d0d", -- Background behind all tabs

			active_tab = {
				bg_color = "#cc4444", -- Bright red for the active tab
				fg_color = "#1a0d0d", -- Dark text for contrast
				intensity = "Bold",
				underline = "None",
				italic = false,
			},

			inactive_tab = {
				bg_color = "#3b1f1f", -- Dull red-brown for inactive tabs
				fg_color = "#f0c0c0", -- Soft pink text
			},

			inactive_tab_hover = {
				bg_color = "#5a2a2a", -- Slightly brighter on hover
				fg_color = "#ffffff",
				italic = true,
			},

			new_tab = {
				bg_color = "#1a0d0d",
				fg_color = "#ff6b6b", -- Reddish-pink icon for new tab
			},

			new_tab_hover = {
				bg_color = "#3b1f1f",
				fg_color = "#ff9999",
				italic = true,
			},
		},
	},

	-- Dim inactive panes (useful in split layouts)
	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.8,
	},

	-- Terminal bell behavior
	audible_bell = "SystemBeep", -- Options: "SystemBeep", "VisualBell", "Disabled"

	-- Custom key bindings
	keys = {
		-- Switch to the left tab
		{
			key = "h",
			mods = "CTRL",
			action = wezterm.action.ActivateTabRelative(-1),
		},
		-- Switch to the right tab
		{
			key = "l",
			mods = "CTRL",
			action = wezterm.action.ActivateTabRelative(1),
		},
		-- Open new tab with Ctrl+T
		{
			key = "t",
			mods = "CTRL",
			action = wezterm.action.SpawnTab("CurrentPaneDomain"),
		},

		-- Close current tab with Ctrl+W (with confirmation)
		{
			key = "w",
			mods = "CTRL",
			action = wezterm.action.CloseCurrentTab({ confirm = true }),
		},

		-- Ctrl+C to copy to clipboard
		{
			key = "c",
			mods = "CTRL",
			action = wezterm.action.CopyTo("Clipboard"),
		},

		-- Ctrl+V to paste from clipboard
		{
			key = "v",
			mods = "CTRL",
			action = wezterm.action.PasteFrom("Clipboard"),
		},

		-- Ctrl+Shift+C to send Ctrl+C (interrupt signal)
		{
			key = "c",
			mods = "CTRL|SHIFT",
			action = wezterm.action.SendKey({
				key = "c",
				mods = "CTRL",
			}),
		},

		-- Alt+1 through Alt+9 to switch tabs
		{ key = "1", mods = "ALT", action = wezterm.action.ActivateTab(0) },
		{ key = "2", mods = "ALT", action = wezterm.action.ActivateTab(1) },
		{ key = "3", mods = "ALT", action = wezterm.action.ActivateTab(2) },
		{ key = "4", mods = "ALT", action = wezterm.action.ActivateTab(3) },
		{ key = "5", mods = "ALT", action = wezterm.action.ActivateTab(4) },
		{ key = "6", mods = "ALT", action = wezterm.action.ActivateTab(5) },
		{ key = "7", mods = "ALT", action = wezterm.action.ActivateTab(6) },
		{ key = "8", mods = "ALT", action = wezterm.action.ActivateTab(7) },
		{ key = "9", mods = "ALT", action = wezterm.action.ActivateTab(8) },

		-- -- Switch to the left tab
		-- {
		-- 	key = "h",
		-- 	mods = "ALT",
		-- 	action = wezterm.action.ActivateTabRelative(-1),
		-- },
		-- -- Switch to the right tab
		-- {
		-- 	key = "l",
		-- 	mods = "ALT",
		-- 	action = wezterm.action.ActivateTabRelative(1),
		-- },
		--
		-- Pane Splitting

		{
			key = "d",
			mods = "ALT",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "s",
			mods = "ALT",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "q",
			mods = "ALT",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},

		{ key = "p", mods = "ALT", action = wezterm.action.ShowLauncher },

		-- Pane Navigation (ALT+h/l/j/k)
		{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
		{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
		{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
		{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
		{
			key = "p",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivateCommandPalette,
		},
	},
}
