module (..., package.seeall)

local globalLayer = display.newGroup()
local collectableSound = audio.loadSound("coin.mp3")

function new(_x, _y)
	
	local collectable = display.newImage( "choco.png" )
	globalLayer:insert(collectable)

	collectable.x = _x
	collectable.y = _y

	physics.addBody(collectable, "static", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = true})

	local function onLocalCollision( event )
        if event.phase == "began" and event.other.name == "skunk" and collectable.isVisible then
			event.other.pickCollectable()
			collectable.isVisible = false
			audio.play( collectableSound )			
        end
	end

	collectable:addEventListener( "collision", onLocalCollision )

	return collectable
end

function getCollectablesLayer()
	return globalLayer
end