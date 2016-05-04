function imdbUrl(imdbId)
  return "http://www.imdb.com/title/" .. imdbId
end

function omdbQuery(query)
  return "http://omdbapi.com/?s=" .. query
end

function searchOmdb()
  local picker = hs.chooser.new(function(userInput)
    if userInput ~= nil then
      hs.execute("open " .. imdbUrl(userInput["imdbId"]) )
    end
  end)

  picker:queryChangedCallback(function(query)
    hs.http.asyncGet(omdbQuery(query), nil, function(status, body, headers)
      if status == 200 then
        searchResult = hs.json.decode(body)
        local values = {}
        hs.fnutils.each(searchResult["Search"], function(each)
          local foundTitle = each["Title"]
          local foundYear = each["Year"]
          local foundImdbId = each["imdbID"]

          table.insert(values, {
            text = foundTitle .. " (" .. foundYear .. ")",
            imdbId = foundImdbId
          })
        end)
        picker:choices(values)
      end
    end)
  end)

  picker:bgDark(true)
  picker:fgColor(hs.drawing.color.x11["white"])
  picker:subTextColor(hs.drawing.color.x11["white"])
  picker:show()
end
