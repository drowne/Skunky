module(..., package.seeall)

function new ()
	local cp = {}

	cp.x = 0
	cp.y = 0
	cp.weight = 1

	return cp
end