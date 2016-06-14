local ip = "192.168.178.18"
local username = "4ae6299e34bd7de24173ad6e16e1fe"
local goLightIndex = 3
local uri = "http://" .. ip .. "/api/" .. username .. "/lights/"

local function randomColor()
  on = "\"on\":true"
  bri = "\"bri\":" .. 255
  hue = "\"hue\":" .. math.random(65535)
  sat = "\"sat\":" .. 255
  return "{" .. on .. ",".. bri .. "," .. hue .. "," .. sat .. "}"
end

function sendHueRequest(lightIndex, state)
  hs.http.doAsyncRequest(uri .. lightIndex .. "/state", "PUT", state, nil, setCorrectIcon)
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
      if userInput["nextStep"] == "controlGo()" then
        controlGo()
      elseif userInput["nextStep"] == "controlWhites()" then
        controlWhites()
      end
    end
  end)

  picker:choices({
    {
      ["text"] = "Go",
      ["subText"] = "Control the Phillips Hue Go",
      ["nextStep"] = "controlGo()"
    },
    {
      ["text"] = "Whites",
      ["subText"] = "Control the Phillips Hue Whites",
      ["nextStep"] = "controlWhites()"
    }
  })

  picker:bgDark(true)
  picker:fgColor(hs.drawing.color.x11["white"])
  picker:subTextColor(hs.drawing.color.x11["white"])
  picker:show()
end

function controlGo()
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

function controlWhites()
  local picker = hs.chooser.new(function(userInput)
    if userInput ~= nil then
      if userInput["action"] == "on" then
        turnOn(1)
        turnOn(2)
      elseif userInput["action"] == "lighter" then
        changeBrightness(1, 25)
        changeBrightness(2, 25)
      elseif userInput["action"] == "darker" then
        changeBrightness(1, -25)
        changeBrightness(2, -25)
      elseif userInput["action"] == "off" then
        turnOff(1)
        turnOff(2)
      end
    end
  end)

  picker:choices({
    {
      ["text"] = "On",
      ["subText"] = "Turn the lights on",
      ["action"] = "on"
    },
    {
      ["text"] = "Lighter",
      ["subText"] = "Decrease the brightness",
      ["action"] = "lighter"
    },
    {
      ["text"] = "Darker",
      ["subText"] = "Increase the brightness",
      ["action"] = "darker"
    },
    {
      ["text"] = "Off",
      ["subText"] = "Turn the lights off",
      ["action"] = "off"
    }
  })

  picker:bgDark(true)
  picker:fgColor(hs.drawing.color.x11["white"])
  picker:subTextColor(hs.drawing.color.x11["white"])
  picker:show()
end

function setCorrectIcon()
  goCurrentlyOn(function()
    local image = hs.image.imageFromPath("icons/lightsOn.png")
    hueMenu:setIcon(image:setSize({w=16, h=16}))
  end,function()
    local image = hs.image.imageFromPath("icons/lightsOff.png")
    hueMenu:setIcon(image:setSize({w=16, h=16}))
  end)
end

function turnAllOn()
  for index=1,3,1 do
    turnOn(index)
  end
end

function turnAllOff()
  for index=1,3,1 do
    turnOff(index)
  end
end

function turnOn(lightIndex)
  sendHueRequest(lightIndex, "{\"on\":true}")
end

function lazyTurnOn(lightIndex)
  return function()
    turnOn(lightIndex)
  end
end

function lazyTurnOff(lightIndex)
  return function()
    turnOff(lightIndex)
  end
end

function turnOff(lightIndex)
  sendHueRequest(lightIndex, "{\"on\":false}")
end

-- todo: check if works
function changeBrightness(lightIndex, change)
  hs.http.asyncGet(uri .. lightIndex, nil, function(status, body, headers)
    response = hs.json.decode(body)
    brightness = response["state"]["bri"]
    newBrightness = clamp(brightness + change, 0, 255)
    if(newBrightness > 0) then
      newState = "{\"on\":true, \"bri\":" .. newBrightness .. "}"
    else
      newState = "{\"on\":false}"
    end
    sendHueRequest(lightIndex, newState)
  end)
end

-- todo : loop through indices
function goCurrentlyOn(onTrue, onFalse)
  hs.http.asyncGet(uri .. goLightIndex, nil, function(status, body, headers)
    if hs.json.decode(body)["state"]["on"] then
      onTrue()
    else
      onFalse()
    end
  end)
end

function hueMenuClicked()
  goCurrentlyOn(turnAllOff, turnAllOn)
end

function startHueMenuIcon()
  hueMenu = hs.menubar.new()
  hueMenu:setClickCallback(hueMenuClicked)
  setCorrectIcon()
end

function changeBrightnessOfHueWhites(change)
  changeBrightness(1, change)
  changeBrightness(2, change)
end

function clamp(newValue, min, max)
  if newValue < min then
    return min
  elseif newValue > max then
    return max
  else
    return newValue
  end
end
