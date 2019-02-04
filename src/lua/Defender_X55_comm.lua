local command = {
  [58] = "mute",
  [200] = {"volume",1},
  [232] = {"volume",-1}
}


local function init()
  local state, result
  if file.open("Defender_X55.init", "r") then
    state, result = pcall(sjson.decode,file.read())
    file.close()
  end
  return result
end

local function bitToNumber(str)
  local b, i = 0, 1
  for s in str:reverse():gmatch(".")do
    b=b+s*i
    i=i*2
  end
  return b
end

return function (s)
  local r = bitToNumber(s)
  print(r)
  local val = init()
  --  tab = {}
--  dofile("Defender_X55.lua")(s)
  return r
end
