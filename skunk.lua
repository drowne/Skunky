module (..., package.seeall)

local globalLayer 	= display.newGroup()

local jumpForce 	= 8
local fartForce		= 3
local canJump 		= true
local canFart		= true
local timeToFart	= 500
local timeToJump 	= 1000

local hspeed, vspeed, oldX, oldY

function new()
	
	-- draw the skunk and add it to the globallayer
	--local skunkImage = display.newImage("skunk.png") 
	--globalLayer:insert(skunkImage)
	--skunkImage.x = 0
	--skunkImage.y = 0
	
	globalLayer.name = "skunk"
	
	globalLayer.x = 400
	globalLayer.y = 0

	physics.addBody(globalLayer, "dynamic", {
									radius = 15,
									density = 1.0, 
									friction = 0.3, 
									bounce = 0.2, 
									isSensor = false,
									isBullet = true})
	
	return globalLayer
end

function globalLayer:pickCollectable()
	print("collectable")
end

function globalLayer:update()

	if oldX and oldY then
		hspeed = globalLayer.x - oldX
		vspeed = globalLayer.y - oldY
		--print("hspeed: " .. hspeed .. " vspeed: " .. vspeed)
	end
	
	oldX = globalLayer.x
	oldY = globalLayer.y

	globalLayer:applyLinearImpulse(0.1,0)
	
end

function globalLayer:getHSpeed()
	return hspeed
end

function globalLayer:getVSpeed()
	return vspeed
end

function globalLayer:getSpeed()
	return hspeed,vspeed
end

function canJumpAgain()
	canJump = true
end

function canFartAgain()
	canFart = true
end

function globalLayer:jump()
	-- check if it can jump or not
	if canJump	then
		globalLayer:applyLinearImpulse(0,-jumpForce)
		canJump = false
		timer.performWithDelay(timeToJump, canJumpAgain)
	end
end

function globalLayer:fart()
	-- check if it can jump or not
	if canFartAgain	then
		globalLayer:applyLinearImpulse(fartForce,0)
		canFart = false
		timer.performWithDelay(timeToFart, canFartAgain)
	end
end