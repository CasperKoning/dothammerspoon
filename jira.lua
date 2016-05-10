-- Jira viewer: (also see https://developer.atlassian.com/jiradev/jira-apis/jira-rest-apis/jira-rest-api-tutorials/jira-rest-api-version-2-tutorial)
require("environment")

function createAuthorisationRequestBody()
  return '{"username": ' .. jiraUsername .. ', "password":' .. jiraPassword .. '}'
end

function getSession()
  data = createAuthorisationRequestBody()
  headers = {["Content-Type"] = "application/json"}
  status, body, returnedHeaders = hs.http.post('https://jira.wehkamp.io/rest/auth/latest/session', data, headers)
  if status == 200 then
    result = hs.json.decode(body)
    session = result["session"]
    return session["name"], session["value"]
  else
    return nil, nil
  end
end

function browseJira()
  sessionName, sessionValue = getSession()
  if (sessionName ~= nil and sessionValue ~= nil) then
    cookieHeaders = {["cookie"] = sessionName .. "=" .. sessionValue, ["Content-Type"] = "application/json"}

    local picker = hs.chooser.new(function(userInput)
      if userInput ~= nil then
        if userInput["key"] ~= nil then
          hs.execute("open " .. jiraUrl(userInput["key"]))
        end
      end
    end)


    picker:queryChangedCallback(function(query)
      hs.http.asyncGet(jiraQuery(query), cookieHeaders, function(status, body, headers)
        if status == 200 then
          searchResult = hs.json.decode(body)
          if searchResult["fields"] ~= nil then
            local results = {}

            local key = searchResult["key"]
            local summary = searchResult["fields"]["summary"]

            table.insert(results, {text = key, subText = summary, key = key})
            picker:choices(results)
          end
        end
      end)
    end)

    picker:bgDark(true)
    picker:fgColor(hs.drawing.color.x11["white"])
    picker:subTextColor(hs.drawing.color.x11["white"])
    picker:rows(1)
    picker:show()
  else
    notify = hs.notify.new()
    notify:title("Jira")
    notify:informativeText("Could not get authorization")
    notify:send()
  end
end

function jiraQuery(query)
  return "https://jira.wehkamp.io/rest/api/latest/issue/" .. query
end

function jiraUrl(key)
  return "https://jira.wehkamp.io/browse/" .. key
end
