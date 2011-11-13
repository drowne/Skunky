module (..., package.seeall)

local globalLayer 	= display.newGroup()

local jumpForce 	= 5
local fartForce		= 6
local canJump 		= true
local canFart		= true
local timeToFart	= 500
local timeToJump 	= 1000

function new()
	
	-- draw the skunk and add it to the globallayer
	--local skunkImage = display.newImage("skunk.png") 
	--globalLayer:insert(skunkImage)
	--skunkImage.x = 0
	--skunkImage.y = 0
	
	globalLayer.name = "skunk"

	physics.addBody(globalLayer, "dynamic", {
									radius = 10,
									density = 1.0, 
									friction = 0.3, 
									bounce = 0.2, 
									isSensor = false})
	
	return globalLayer
end

function globalLayer:pickCollectable()
	print("collectable")
end

function globalLayer:update()
	--print("update")
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