function random_color()
  on = "\"on\":true"
  bri = "\"bri\":" .. 255
  hue = "\"hue\":" .. math.random(65535)
  sat = "\"sat\":" .. 255
  return "{" .. on .. ",".. bri .. "," .. hue .. "," .. sat .. "}"
end

function send_hue_request(state)
  hs.http.doRequest(uri, "PUT", state, nil)
end

function choose_color()
  local picker = hs.chooser.new(function(userInput)
    if userInput ~= nil then
      send_hue_request(userInput["new_state"])
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

function control_hue(ip, username, light_index)
  uri = "http://" .. ip .. "/api/" .. username .. "/lights/" .. light_index .. "/state"

  local picker = hs.chooser.new(function(userInput)
    if userInput ~= nil then
      if userInput["next_step"] == "choose_color()" then
        choose_color()
      else
        send_hue_request(userInput["new_state"])
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
