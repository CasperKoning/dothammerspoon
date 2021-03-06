hs.window.animationDuration = 0

require("hue")
require("windowManagement")
require("browserShortcuts")
require("omdb")
require("hsDevUtils")
require("wifi")

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

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "=", function()
  changeBrightnessOfHueWhites(10)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "-", function()
  changeBrightnessOfHueWhites(-10)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "i", function()
  searchOmdb()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "r", function()
  reloadHsConfig()
end)

hs.hotkey.bind({"cmd", "alt"}, "X", function()
  workOnHammerspoonMode()
end)

startHueMenuIcon()

watchForWifiConnectionEvent()

hs.alert.show("Conf reloaded")
