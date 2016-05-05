function moveCurrentWindowToLeftHalf()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end

function moveCurrentWindowToRightHalf()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end

function maximizeCurrentWindow()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end

function workOnHammerspoonMode()
  hs.openConsole(true)
  hs.application("Atom"):activate(true)

  local windowLayout = {
      {"Atom",          nil, "Color LCD", hs.layout.left50,           nil, nil},
      {"Hammerspoon",   nil, "Color LCD", {x=0.5, y=0, w=0.5, h=0.9}, nil, nil}
  }
  hs.layout.apply(windowLayout)
end
