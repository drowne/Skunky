module (..., package.seeall)

-- includes
local physics     = require("physics")
local skunk       = require("skunk")
local Collectable = require("collectable")
local highscore	  = require("highscore")

-- global variables
_G.firstTouch     = true
_G.gameStarted    = false
_G.gameEnded      = false
_G.score          = 0
_G.localhighscore = 0

-- drawing variables
local globalLayer = display.newGroup()
local skunkInstance

-- utils variables
local _H = display.contentHeight
local _W = display.contentWidth

function init()
	physics.setDrawMode( "hybrid" )
	physics.start()
	-- load highscore
	_G.localhighscore = highscore.getHighScore()
end

function setupBackground()
	
	local background = display.newImage("background.png")
	globalLayer:insert(background)
	background.x = _W/2
	background.y = _H/2
	background:scale(1.5, 1.5)
	
end

function update()
	--skunkInstance.update()
end

function onTap(event)
	
	if not _G.firstTouch then
		if not _G.gameEnded then
			skunkInstance.jump()			
		end
	else
		_G.firstTouch = false
	end
	
end

function removeListeners()
	Runtime:removeEventListener("enterFrame", update)
	Runtime:removeEventListener("tap", onTap)
end

function populateCollectables()

	-- create a collectable
	local choco1 = Collectable.new(0, 100)

end

function new()
	
	init()
	setupBackground()
	
	skunkInstance = skunk.new()
	globalLayer:insert(skunkInstance)
	globalLayer:insert(Collectable.getCollectablesLayer())

	populateCollectables()

	Runtime:addEventListener("enterFrame", update)
	Runtime:addEventListener("tap", onTap)
	
	return globalLayer
end