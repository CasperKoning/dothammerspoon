function urlEncode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w %-%_%.%~])", function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, "^%s*(.-)%s*$", "%1")
    str = string.gsub (str, " ", "+")
  end
  return str
end

function imdbUrl(imdbId)
  return "http://www.imdb.com/title/" .. imdbId
end

function omdbQuerySearch(query)
  return "http://omdbapi.com/?s=" .. urlEncode(query)
end

function createPosterView(element, index)
  local posterView = hs.webview.new(hs.geometry(408, 187 + 37 * (index - 1), 25, 38))
  posterView:url(element["Poster"])
  posterView:show()
  return posterView
end

function searchOmdb()
  local picker = hs.chooser.new(function(userInput)
    if userInput ~= nil then
      hs.execute("open " .. imdbUrl(userInput["imdbId"]))
    end
  end)

  picker:queryChangedCallback(function(query)
    hs.http.asyncGet(omdbQuerySearch(query), nil, function(status, body, headers)
      if status == 200 then
        searchResult = hs.json.decode(body)
        local choices = {}
        if searchResult["Search"] ~= nil then
          hs.fnutils.each(searchResult["Search"], function(each)
            local foundTitle = each["Title"]
            local foundYear = each["Year"]
            local foundImdbId = each["imdbID"]

            table.insert(choices, {
              text = foundTitle .. " (" .. foundYear .. ")",
              subText = foundPlot,
              imdbId = foundImdbId
            })
          end)
        end

        picker:choices(choices)
      end
    end)
  end)

  picker:bgDark(true)
  picker:fgColor(hs.drawing.color.x11["white"])
  picker:subTextColor(hs.drawing.color.x11["white"])
  picker:show()
end
