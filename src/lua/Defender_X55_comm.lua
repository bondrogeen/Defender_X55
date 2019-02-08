
local command = {
  [58] = {"mute",0},
  [216] = {"mute",0},
  [200] = {"volume",1},
  [232] = {"volume",-1},
  [26] = {"subwoofer",1},
  [154] = {"subwoofer",-1},
  [146] = {"treble",1},
  [178] = {"treble",-1},
  [18] = {"bass",1},
  [50] = {"bass",-1},
}

local function bitToNumber(str)
  local b, i = 0, 1
  for s in str:reverse():gmatch(".")do
    b=b+s*i
    i=i*2
  end
  return b
end

return function (level)
  local byte, t, tab = bitToNumber(level), {}
  local comm = command[byte]
  if(comm) and _Defender then
    t[comm[1]] = comm[1] == "mute" and (_Defender[comm[1]] == 1 and 0 or 1) or _Defender[comm[1]] + comm[2]
    dofile("Defender_X55.lua")(t)
  end
end
