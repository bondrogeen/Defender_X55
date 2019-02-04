local lastTime, com, one = 0, "", true

local function onEdge(level, ts)
 local l = ts - lastTime
 lastTime = ts
 if l>13000 and l<16000 then com="" one=true end
 if l>1000 and l<1500 then com=com..0 end
 if l>2000 and l<2500 then com=com..1 end
 if com:len()==32 and one then
   print(com:sub(17,24))
   one=false
   end
 if l>90000 and l<100000 then
 if com:len()==32 then
  print(com:sub(17,24))
 else
  print("error")
 end
 end
end
gpio.mode(1,gpio.INT)
gpio.trig(1,"down",onEdge)
