module (..., package.seeall)

local Vector2D = require("vector2d")

local globalLayer 	= display.newGroup()

local SPEED_LIMIT 	= 500
local DAMPING 		= 5

local jumpForce 	= 200
local fartForce		= 300
local canJump 		= true
local canFart		= true
local timeToFart	= 1000
local timeToJump 	= 1000

local hspeed, vspeed, oldX, oldY

function new()
	
	-- draw the skunk and add it to the globallayer
	local skunkImage = display.newImage("skunk.png") 
	globalLayer:insert(skunkImage)
	skunkImage.x = 0
	skunkImage.y = 0
	
	globalLayer.name = "skunk"
	
	globalLayer.x = 400
	globalLayer.y = 0
	globalLayer.collectableCount = 0

	physics.addBody(globalLayer, {
									radius = 15,
									density = 1, 
									friction = 0.3, 
									bounce = 0.2, 
									isSensor = false,
									isBullet = true
								})
	
	--globalLayer.isSleepingAllowed = false

	return globalLayer
end

function globalLayer:pickCollectable()
	globalLayer.collectableCount = globalLayer.collectableCount + 1
	--print("collectable")
end

function globalLayer:update()

	if oldX and oldY then
		hspeed = globalLayer.x - oldX
		vspeed = globalLayer.y - oldY
		--print("hspeed: " .. hspeed .. " vspeed: " .. vspeed)
	end
	
	oldX = globalLayer.x
	oldY = globalLayer.y

	local vx, vy = globalLayer:getLinearVelocity()
	local velocity = Vector2D:new(vx, vy)
	local speed = velocity:magnitude()
	
	if(speed > SPEED_LIMIT) then
		globalLayer.linearDamping = DAMPING
	else
		globalLayer.linearDamping = 0 
	end

	--globalLayer:applyLinearImpulse(0.1,0)
	
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
		--globalLayer:applyLinearImpulse(0,-jumpForce)
		globalLayer:applyForce(0, -jumpForce, globalLayer.x, globalLayer.y)
		canJump = false
		timer.performWithDelay(timeToJump, canJumpAgain)
	end
end

function globalLayer:fart()
	-- check if it can jump or not
	if canFart	then
		globalLayer:applyForce(fartForce, 0, globalLayer.x, globalLayer.y)
		canFart = false
		timer.performWithDelay(timeToFart, canFartAgain)
	end
end