module (..., package.seeall)

local globalLayer 	= display.newGroup()

local jumpForce 	= 5
local isGrounded 	= true
local canJump 		= true
local timeToJump 	= 1000

function new()
	
	-- draw the skunk and add it to the globallayer
	--local skunkImage = display.newImage("skunk.png") 
	--globalLayer:insert(skunkImage)
	--skunkImage.x = 0
	--skunkImage.y = 0
	
	physics.addBody(globalLayer, "dynamic", {
									radius = 10,
									density = 1.0, 
									friction = 0.3, 
									bounce = 0.2, 
									isSensor = false})
	
	return globalLayer
end

function globalLayer:update()
	--print("update")
end

function canJumpAgain()
	canJump = true
end

function globalLayer:jump()
	
	-- check if it's on ground and
	-- thus can jump or not
	if(isGrounded and canJump)	then
		globalLayer:applyLinearImpulse(0,-jumpForce)
		canJump = false
		timer.performWithDelay(timeToJump, canJumpAgain)
	end
end