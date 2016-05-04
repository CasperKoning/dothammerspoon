function watchForWifiConnectionEvent ()
  hs.wifi.watcher.new(function()
    local currentNetwork = hs.wifi.currentNetwork()
    local notify = hs.notify.new()
    if currentNetwork == nil then
      notify:informativeText("Disconnected from WiFi!")
    else
      notify:informativeText("Connected to WiFi: " ..currentNetwork)
    end
    notify:title("WiFi")
    notify:contentImage(hs.image.imageFromPath("icons/wifi.ico"))
    notify:send()
  end):start()
end
