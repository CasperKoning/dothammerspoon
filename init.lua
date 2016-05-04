hs.window.animationDuration = 0

require("hue")
require("window_management")
require("browser_shortcuts")
require("jira")
require("omdb")
require("hs_dev_utils")
require("wifi")

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  move_current_window_to_left_half()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  move_current_window_to_right_half()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
  maximize_current_window()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "g", function()
  open_g()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "h", function()
  control_hue()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "j", function()
  browse_jira()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "i", function()
  searchOmdb()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "c", function()
  delete_webthing()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "r", function()
  reload_hs_config()
end)

startHueMenuIcon()

watchForWifiConnectionEvent()

hs.alert.show("Conf reloaded")
