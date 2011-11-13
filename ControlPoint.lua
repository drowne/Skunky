module(..., package.seeall)

function new ()
	local globalLayer = display.newGroup()

	globalLayer.x = 0
	globalLayer.y = 0
	globalLayer.weight = 1

	return globalLayer
end