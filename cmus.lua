function togglePlayback()
  hs.execute("/usr/local/bin/cmus-remote -u")
end

function skipSong()
  hs.execute("/usr/local/bin/cmus-remote -n")
end

function previousSong()
  hs.execute("/usr/local/bin/cmus-remote -r")
end
