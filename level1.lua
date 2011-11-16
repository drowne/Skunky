module (..., package.seeall)

-- includes
local physics     = require("physics")
local skunk       = require("skunk")
local Collectable = require("collectable")
local highscore   = require("highscore")
local ground      = require("ground")

-- utils variables
local _H = display.contentHeight
local _W = display.contentWidth

-- global variables
_G.firstTouch     = true
_G.gameStarted    = false
_G.gameEnded      = false
_G.score          = 0
_G.localhighscore = 0

-- drawing variables
local globalLayer = display.newGroup()
local skunkInstance
local startPointX = -_H/2.4
local startPointY = 200
local targetX = _H * 1.2
local targetY = _W * 1.5

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
			--ground.addPoints(event.x, event.y)			
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
	--local choco1 = Collectable.new(0, 100)

end

function new()
	
	init()
	setupBackground()
	
	skunkInstance = skunk.new()
	globalLayer:insert(skunkInstance)
	globalLayer:insert(Collectable.getCollectablesLayer())

	globalLayer:insert(ground.initialize())
	ground.newGround(startPointX, startPointY, targetX, targetY, parent)

	populateCollectables()

	Runtime:addEventListener("enterFrame", update)
	Runtime:addEventListener("tap", onTap)
	
	return globalLayer
end