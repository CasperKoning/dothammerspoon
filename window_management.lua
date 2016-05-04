function move_current_window_to_left_half()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end

function move_current_window_to_right_half()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end

function maximize_current_window()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end
