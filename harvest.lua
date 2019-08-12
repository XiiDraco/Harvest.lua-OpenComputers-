local component = require("component")
local term = require("term")
local sides = require("sides")
local shell = require("shell")
local os = require("os")
 
if not component.isAvailable("robot") then
  io.stderr:write("Can only run on robots.")
  return
end
 
local robot = require("robot")
 
local args, options = shell.parse(...)
 
if #args < 3 then
  print("Usage: harvest [x] [y] [wait time in seconds]")
  return
end
 
local width = tonumber(args[1])
local height = tonumber(args[2])
local waitTime = tonumber(args[3])
local moves = 0
local maxMoves = width * height
 
if width < 2 or height < 2 then
  io.stderr:write("Width and Height must be atleast 2.")
  return
end
 
local x = 1
local y = 0
local BACKWARD = 0
local FORWARD = 1
 
local HARVEST = 0
local RETURN = 1
local EMPTY_INVENTORY = 2
local WAIT = 3
 
local direction = FORWARD
local state = HARVEST
local harvestSetup = false
 
function toString(bool)
  if bool == true then
    return "true"
  else
    return "false"
  end
end
 
function plant()
  robot.swingDown()
  robot.suckDown()
  local placed = false
  local slot = 0
  while not placed do
    placed = robot.placeDown()
    if placed == true then
      return
    end
 
    slot = slot + 1
    if slot > robot.inventorySize() then
      robot.select(1)
      return
    end
    robot.select(slot)
  end
end
 
function forceForward()
  local moveOn = false
  while not moveOn do
    moveOn = robot.forward()
    if moveOn == nil then
      print("Removing obstacle.")
      robot.swing(sides.front)
    end
  end  
end
 
term.clear()
 
while true do
   
  while state == HARVEST do
    if harvestSetup == false then
      forceForward()
      robot.turnRight()
      robot.useDown(sides.front)
      harvestSetup = true
      x = 1
      y = 1
      moves = 1
      plant()
      term.clear()
      print("Harvesting.")
    end
 
    if x == width and direction == FORWARD then
      direction = BACKWARD
      robot.turnLeft()
      forceForward()
      robot.turnLeft()
      y = y + 1
    elseif x == 1 and direction == BACKWARD then
      direction = FORWARD
      robot.turnRight()
      forceForward()
      robot.turnRight()
      y = y + 1
    elseif direction == FORWARD then
      forceForward()
      x = x + 1
    elseif direction == BACKWARD then
      forceForward()
      x = x - 1
    end
 
    moves = moves + 1
 
    if moves >= maxMoves then
      state = RETURN
    end    
 
    plant()
  end
 
  if state == RETURN then
    print("Returning to start position.")
    if direction == FORWARD then    
      robot.turnLeft()
      robot.turnLeft()
      for i = 1, x-1, 1 do
        forceForward()      
      end
    end
    robot.turnLeft()
    for i = 1, y, 1 do
      forceForward()
    end
    state = EMPTY_INVENTORY    
  end
 
  if state == EMPTY_INVENTORY then
    robot.turnLeft()
    robot.turnLeft()
    local size = robot.inventorySize()
    for i = 1, size, 1 do
      robot.select(i)
      robot.dropDown()
    end
    robot.select(1)
    state = WAIT
  end
 
  if state == WAIT then
    print("Waiting for " .. waitTime .. " seconds.")
    os.sleep(waitTime)
    state = HARVEST
    harvestSetup = false
    direction = FORWARD
    x = 1
    y = 0
  end
end
