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

Janosh:subscribe("line", push)
Janosh:subscribe("clear", push)

-- Open websocket
Janosh:wsOpen(8090)
Janosh:wsOnReceive(receive)

function sierpinski_tri(size)
local m = {}
m[math.floor(size/2)] = true
line = {}
local n
for i = 1, size do
  n = {}
  line = ""
  for j = 1, size do
    if m[j] then
      line = line .. "1"
      n[j+1] = not n[j+1]
      n[j-1] = not n[j-1]
    else
      line = line .. "0";
    end
  end
 Janosh:publish("line","W", JSON:encode({ i, line }))
  m = n
end

end
while true do
       Janosh:publish("clear", "W", "")
       sierpinski_tri(500)
end

