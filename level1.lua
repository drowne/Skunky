module (..., package.seeall)

-- includes
local physics = require("physics")
local skunk = require("skunk")

local globalLayer = display.newGroup()
local skunkInstance

local _H = display.contentHeight
local _W = display.contentWidth

function init()
	physics.setDrawMode( "hybrid" )
	physics.start()
end

function setupBackground()
	
	local background = display.newImage("background.png")
	globalLayer:insert(background)
	background.x = _W/2
	background.y = _H/2
	background:scale(1.5, 1.5)
	
end

function new()
	
	init()
	setupBackground()
	
	skunkInstance = skunk.new()
	globalLayer:insert(skunkInstance)
	
	return globalLayer
end