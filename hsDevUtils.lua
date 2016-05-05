function deleteWebthing()
  webThing:delete()
end

function reloadHsConfig()
  hs.reload()
end

function printTable(table) for k,v in pairs(table) do; print(k,v) end end
