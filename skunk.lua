module (..., package.seeall)

local globalLayer = display.newGroup()

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