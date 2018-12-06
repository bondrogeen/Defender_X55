local function bitToNumber(str)
 local b,i=0,1
 for s in str:reverse():gmatch(".")do b=b+s*i i=i*2 end
 return b
end

return function (s)
 local r = bitToNumber(s)

 return r
end
