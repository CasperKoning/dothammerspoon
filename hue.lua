local ip = "192.168.178.18"
local username = "4ae6299e34bd7de24173ad6e16e1fe"
local lightIndex = 3
local uri = "http://" .. ip .. "/api/" .. username .. "/lights/" .. lightIndex

local function randomColor()
  on = "\"on\":true"
  bri = "\"bri\":" .. 255
  hue = "\"hue\":" .. math.random(65535)
  sat = "\"sat\":" .. 255
  return "{" .. on .. ",".. bri .. "," .. hue .. "," .. sat .. "}"
end

function sendHueRequest(state)
  hs.http.doAsyncRequest(uri .. "/state", "PUT", state, nil, setCorrectIcon)
end

function chooseColor()
  local picker = hs.chooser.new(function(userInput)
    if userInput ~= nil then
      sendHueRequest(userInput["newState"])
    end
  end)

  picker:choices({
    {
      ["text"] = "Red",
      ["newState"] = "{\"on\": true, \"bri\": 255, \"hue\": 0 , \"sat\": 255 }"
    },
    {
      ["text"] = "Green",
      ["newState"] = "{\"on\": true, \"bri\": 255, \"hue\": 27535, \"sat\": 255 }"
    },
    {
      ["text"] = "Blue",
      ["newState"] = "{\"on\": true, \"bri\": 255, \"hue\": 42535, \"sat\": 255 }"
    },
    {
      ["text"] = "Pink",
      ["newState"] = "{\"on\": true, \"bri\": 255, \"hue\": 55535, \"sat\": 255 }"
    }
  })

  picker:bgDark(true)
  picker:fgColor(hs.drawing.color.x11["white"])
  picker:subTextColor(hs.drawing.color.x11["white"])
  picker:show()
end

function controlHue()
  local picker = hs.chooser.new(function(userInput)
    if userInput ~= nil then
      if userInput["nextStep"] == "chooseColor()" then
        chooseColor()
      else
        sendHueRequest(userInput["newState"])
      end
    end
  end)

  picker:choices({
    {
      ["text"] = "On",
      ["subText"] = "Turn the light on",
      ["newState"] = "{\"on\":true}",
      ["nextStep"] = "sendHueRequest()"
    },
    {
      ["text"] = "Random",
      ["subText"] = "Use a random color",
      ["newState"] = randomColor(),
      ["nextStep"] = "sendHueRequest()"
    },
    {
      ["text"] = "Pick Color",
      ["subText"] = "Pick a color",
      ["nextStep"] = "chooseColor()"
    },
    {
      ["text"] = "Off",
      ["subText"] = "Turn off",
      ["newState"] = "{\"on\":false}",
      ["nextStep"] = "sendHueRequest()"
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
  sendHueRequest("{\"on\":true}")
end

function turnOff()
  sendHueRequest("{\"on\":false}")
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
