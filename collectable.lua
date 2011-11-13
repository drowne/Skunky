module (..., package.seeall)

local globalLayer = display.newGroup()

function new(_x, _y)
	
	local collectable = display.newImage( "choco.png" )
	globalLayer:insert(collectable)

	collectable.x = _x
	collectable.y = _y

	physics.addBody(collectable, "static", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = true})

	return collectable
end

function getCollectablesLayer()
	return globalLayer
end