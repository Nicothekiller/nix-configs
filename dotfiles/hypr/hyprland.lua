-- Hyprland configuration (Lua) — https://wiki.hypr.land/Configuring/Start/

-- DMS_STARTUP_BEGIN
hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	hl.exec_cmd("systemctl --user start hyprland-session.target")
end)
-- DMS_STARTUP_END

hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_QPA_PLATFORMTHEME_QT6", "qt6ct")
hl.env("XCURSOR_THEME", "breeze_cursors")
hl.env("XDG_MENU_PREFIX", "")

hl.config({
	input = {
		kb_layout = "latam",
		numlock_by_default = true,
		kb_options = "caps:swapescape",
		follow_mouse = 0,
		touchpad = {
			tap_to_click = true,
			natural_scroll = false,
		},
	},
	general = {
		gaps_in = 5,
		gaps_out = 5,
		border_size = 2,
		layout = "scrolling",
	},
	decoration = {
		rounding = 12,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 30,
			render_power = 5,
			offset = "0 5",
			color = "rgba(00000070)",
		},
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
	xwayland = {
		force_zero_scaling = true,
	},
	dwindle = {
		preserve_split = true,
	},
	master = {
		mfact = 0.5,
	},
})

hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "default" })

hl.window_rule({ match = { class = "^(org\\.wezfurlong\\.wezterm)$" }, tile = true })
hl.window_rule({ match = { class = "^(org\\.gnome\\.)" }, rounding = 12 })
hl.window_rule({ match = { class = "^(gnome-control-center)$" }, tile = true })
hl.window_rule({ match = { class = "^(pavucontrol)$" }, tile = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, tile = true })
hl.window_rule({ match = { class = "^(org\\.gnome\\.Calculator)$" }, float = true })
hl.window_rule({ match = { class = "^(gnome-calculator)$" }, float = true })
hl.window_rule({ match = { class = "^(galculator)$" }, float = true })
hl.window_rule({ match = { class = "^(blueman-manager)$" }, float = true })
hl.window_rule({ match = { class = "^(org\\.gnome\\.Nautilus)$" }, float = true })
hl.window_rule({ match = { class = "^(xdg-desktop-portal)$" }, float = true })
hl.window_rule({
	match = { class = "^(steam)$", title = "^(notificationtoasts)" },
	no_initial_focus = true,
	pin = true,
})
hl.window_rule({
	match = { title = "^(Picture-in-Picture)$" },
	float = true,
	pin = true,
})
hl.window_rule({ match = { class = "^(zoom)$" }, float = true })
hl.window_rule({ match = { title = "^(KCalc)$" }, float = true })
hl.layer_rule({ match = { namespace = "^(quickshell)$" }, no_anim = true })
hl.layer_rule({ match = { namespace = "^dms:.*" }, no_anim = true })

hl.bind("XF86Calculator", hl.dsp.exec_cmd("kcalc"))

require("dms.colors")
require("dms.outputs")
require("dms.layout")
require("dms.cursor")
require("dms.binds")
require("dms.binds-user")
require("dms.windowrules")
