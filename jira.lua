-- Jira viewer: (also see https://developer.atlassian.com/jiradev/jira-apis/jira-rest-apis/jira-rest-api-tutorials/jira-rest-api-version-2-tutorial)

function browseJira()
  local picker = hs.chooser.new(function(userInput)
    if userInput ~= nil then
      if userInput["url"] ~= nil then
        hs.execute("open " .. userInput["url"])
      end
    end
  end)


  picker:queryChangedCallback(function(query)
    hs.http.asyncGet(jiraQuery(query), nil, function(status, body, headers)
      searchResult = hs.json.decode(body)
      if searchResult["fields"] ~= nil then
        local results = {}

        local key = searchResult["key"]
        local summary = searchResult["fields"]["summary"]
        local selfUrl = searchResult["self"]

        table.insert(results, {text = key .. ": " .. summary, url = selfUrl})
        picker:choices(results)
      end
    end)
  end)

  picker:bgDark(true)
  picker:fgColor(hs.drawing.color.x11["white"])
  picker:subTextColor(hs.drawing.color.x11["white"])
  picker:show()
end

function jiraQuery(str)
  return "https://jira.wehkamp.io/rest/api/latest/issue/" .. str .. "?expand=summary"
end
