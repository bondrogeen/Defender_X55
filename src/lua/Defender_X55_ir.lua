local lastTime, com, one, time = 0, "", true

if adc.force_init_mode(adc.INIT_ADC ) then
  node.restart()
end

local function onEdge(level, timeStamp)
  time = timeStamp - lastTime
  lastTime = timeStamp
  if time > 13000 and time < 16000 then com = "" one = true end
  if time > 1000 and time < 1500 then com = com..0 end
  if time > 2000 and time < 2500 then com = com..1 end
  if com:len() == 32 and one then
    dofile("Defender_X55_comm.lua")(com:sub(17,24))
    one = false
  end
  if time > 90000 and time < 100000 then
    if com:len()==32 then
      dofile("Defender_X55_comm.lua")(com:sub(17,24))
    else
      print("error")
    end
  end
end

local function debounce (func,pin)
  local last, delay = 0, 200000
  return function (l,w,t)
  local now = tmr.now()
  if now - last < delay then return end
    last = now
    return func(pin)
  end
end

local function onChange (p)
  if gpio.read(p) == 0 then
    local val = adc.read(0)
    if val > 0 and val < 50 then x = "11011000" end
    if val > 400 and val < 450 then x = "11001000" end
    if val > 550 and val < 600 then x = "11101000" end
    if val > 650 and val < 700 then x = "00011010" end
    if val > 700 and val < 800 then x = "10011010" end
    dofile("Defender_X55_comm.lua")(x or "0")
  end
end

gpio.mode(2, gpio.INT)
gpio.trig(2, 'low', debounce(onChange,2))  -- adc button
gpio.mode(1, gpio.INT)
gpio.trig(1,"down",onEdge) -- ir command
