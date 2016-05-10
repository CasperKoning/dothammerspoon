hs.window.animationDuration = 0

require("hue")
require("windowManagement")
require("browserShortcuts")
require("jira")
require("omdb")
require("hsDevUtils")
require("wifi")
require("cmus")

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  moveCurrentWindowToLeftHalf()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  moveCurrentWindowToRightHalf()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
  maximizeCurrentWindow()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "g", function()
  openG()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "d", function()
  openHammerspoonDocs()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "h", function()
  controlHue()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "j", function()
  browseJira()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "i", function()
  searchOmdb()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "X", function()
  deleteWebthing()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "r", function()
  reloadHsConfig()
end)

hs.hotkey.bind({"cmd", "alt"}, "X", function()
  workOnHammerspoonMode()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function()
  toggleCmusPlayback()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"} , "V", function()
  skipSongCmus()
end)

startHueMenuIcon()

watchForWifiConnectionEvent()

hs.alert.show("Conf reloaded")
