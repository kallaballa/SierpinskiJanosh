#!/lounge/bin/janosh -f

function receive(handle, message)
  Janosh:transaction(function()
    if message == 'setup' then
      Janosh:wsSend(handle, janosh_request({"get","/."}))
    end
  end)

end

-- Broadcast MQ messages to all clients
function push(key, op, value)
	-- Broadcast 
	Janosh:wsBroadcast(JSON:encode({key, op, value}))
end

Janosh:subscribe("update", push)
Janosh:subscribe("clear", push)

-- Open websocket
Janosh:wsOpen(8090)
Janosh:wsOnReceive(receive)

function sierpinski_tri(size)
local m = {}
m[math.floor(size/2)] = true
local n
for i = 1, size do
  n = {}
  local line = ""
  for j = 1, math.ceil(size / 8) do
    local b = 0
    for k = 1, 8 do
      if m[j * 8 + k] then
	local mask = bit.lshift(1,(8-k))
	b = bit.bor(b,mask);
        n[j*8+k+1] = not n[j*8+k+1]
        n[j*8+k-1] = not n[j*8+k-1]
      end  
    end
    line = line .. string.char(b)
  end
  Janosh:publish("update","W",JSON:encode({i, Janosh:enc64(line)}))
  m = n
end
end
while true do
       Janosh:publish("clear", "W", "")
       sierpinski_tri(500)
       Janosh:sleep(1000)      
end

