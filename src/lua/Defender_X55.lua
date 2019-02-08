local function set(val)
  i2c.start(0)
  local r=i2c.address(0,0x44,i2c.TRANSMITTER)
  i2c.write(0,val)
  i2c.stop(0)
  return r
end

local function save(tab)
  local status, result = pcall(sjson.encode, tab)
  if result and file.open("Defender_X55.init", "w") then
    file.write(result)
    file.close()
  end
  return status
end

local function sort(m,v)
  local r

  if not tonumber(v) then
    return false
  end

  v = tonumber(v)
  m = string.lower(m)
  if m=="volume"then r=(v<=63 and v>=0)and set(63-v)
  elseif m == "left" then r=(v<=31 and v>=0) and set(128+31-v)
  elseif m == "right" then r=(v<=31 and v>=0) and set(160+31-v)
  elseif m == "lr" then r=(v<=31 and v>=0) and set(192+31-v)
  elseif m == "subwoofer" then r=(v<=31 and v>=0) and set(224+31-v)
  elseif m == "mute" then if (v==1 or v == 0) then gpio.write(5,v) r=v else r=false end
  elseif m == "input" then r=(v<=3 and v >= 1)and set(79+v)
  elseif m == "bass" then r=(v<=7 and v >= 0) and set(96+v) or (v <= 15 and v >= 8) and set(111+8-v)
  elseif m == "treble" then r=(v<=7 and v >= 0) and set(112+v) or (v <= 15 and v >= 8) and set(127+8-v)
  end

  if r then
    _Defender[m] = v
    print(m..": "..v)
    if m == "mute" then save(_Defender)end
    if _M then
      _M:pub("Defender_X55/info/"..m,v)
    end
  end
  return r
end

return function (data)
  if not _Defender then return end
  local result, state = {}
  for key, value in pairs(data) do
    state = sort(key, value)
    if state ~= nil then
      result[key] = state
    end
  end
  return result
end
