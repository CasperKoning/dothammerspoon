function toggleCmusPlayback()
  hs.execute("/usr/local/bin/cmus-remote -u")
end

function skipSongCmus()
  hs.execute("/usr/local/bin/cmus-remote -n")
end
