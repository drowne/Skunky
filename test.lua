module (..., package.seeall)

local ControlPoint = require("ControlPoint")

new = function(x, y)
	
	-- #PRIVATE VARIABLES
	local self = {}       -- Object to return
	x = x or 0            -- Default if nil
	y = y or 0            -- Default if nil

	self.variable = "variable"

	self.bla2 = bla2

	return self         --VERY IMPORTANT, RETURN ALL THE METHODS!
end


function bla2(self)
	print(self.variable)
end