local ip = "192.168.178.18"
local username = "4ae6299e34bd7de24173ad6e16e1fe"
local light_index = 3
local uri = "http://" .. ip .. "/api/" .. username .. "/lights/" .. light_index

function random_color()
  on = "\"on\":true"
  bri = "\"bri\":" .. 255
  hue = "\"hue\":" .. math.random(65535)
  sat = "\"sat\":" .. 255
  return "{" .. on .. ",".. bri .. "," .. hue .. "," .. sat .. "}"
end

function send_hue_request(state, callback)
  hs.http.doAsyncRequest(uri .. "/state", "PUT", state, nil, callback)
end

function choose_color()
  local picker = hs.chooser.new(function(userInput)
    if userInput ~= nil then
      send_hue_request(userInput["new_state"], function()
        -- empty callback
      end)
    end
  end)

  picker:choices({
    {
      ["text"] = "Red",
      ["new_state"] = "{\"on\": true, \"bri\": 255, \"hue\": 0 , \"sat\": 255 }"
    },
    {
      ["text"] = "Green",
      ["new_state"] = "{\"on\": true, \"bri\": 255, \"hue\": 27535, \"sat\": 255 }"
    },
    {
      ["text"] = "Blue",
      ["new_state"] = "{\"on\": true, \"bri\": 255, \"hue\": 42535, \"sat\": 255 }"
    },
    {
      ["text"] = "Pink",
      ["new_state"] = "{\"on\": true, \"bri\": 255, \"hue\": 55535, \"sat\": 255 }"
    }
  })

  picker:bgDark(true)
  picker:fgColor(hs.drawing.color.x11["white"])
  picker:subTextColor(hs.drawing.color.x11["white"])
  picker:show()
end

function control_hue()
  local picker = hs.chooser.new(function(userInput)
    if userInput ~= nil then
      if userInput["next_step"] == "choose_color()" then
        choose_color()
      else
        send_hue_request(userInput["new_state"], function()
          -- empty callback
        end)
      end
    end
  end)

  picker:choices({
    {
      ["text"] = "On",
      ["subText"] = "Turn the light on",
      ["new_state"] = "{\"on\":true}",
      ["next_step"] = "send_hue_request()"
    },
    {
      ["text"] = "Random",
      ["subText"] = "Use a random color",
      ["new_state"] = random_color(),
      ["next_step"] = "send_hue_request()"
    },
    {
      ["text"] = "Pick Color",
      ["subText"] = "Pick a color",
      ["next_step"] = "choose_color()"
    },
    {
      ["text"] = "Off",
      ["subText"] = "Turn off",
      ["new_state"] = "{\"on\":false}",
      ["next_step"] = "send_hue_request()"
    }
  })

  picker:bgDark(true)
  picker:fgColor(hs.drawing.color.x11["white"])
  picker:subTextColor(hs.drawing.color.x11["white"])
  picker:show()
end

function setCorrectIcon()
  isCurrentlyOn(function()
    title = "HUE OFF"
    hueMenu:setTitle(title)
  end,function()
    title = "HUE ON"
    hueMenu:setTitle(title)
  end)
end

function turnOn()
  send_hue_request("{\"on\":true}", setCorrectIcon)
end

function turnOff()
  send_hue_request("{\"on\":false}", setCorrectIcon)
end

function isCurrentlyOn(onTrue, onFalse)
  hs.http.asyncGet(uri, nil, function(status, body, headers)
    if hs.json.decode(body)["state"]["on"] then
      onTrue()
    else
      onFalse()
    end
  end)
end

function hueMenuClicked()
  isCurrentlyOn(turnOff,turnOn)
end

function startHueMenuIcon()
  hueMenu = hs.menubar.new()
  hueMenu:setClickCallback(hueMenuClicked)
  setCorrectIcon()
end
