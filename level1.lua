module (..., package.seeall)

-- includes
local physics     = require("physics")
local skunk       = require("skunk")
local highscore   = require("highscore")
local ground      = require("ground")
local test		  = require("test")
local Collectable = require("collectable")

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
local UILayer = display.newGroup()
local skunkInstance
local startPointX = -_H/2.4
local startPointY = 200
local targetX = _H * 1.2
local targetY = _W * 1.5
local clouds = display.newImage("clouds.png")

local scoreText
local collectableText

function init()
	--physics.setDrawMode( "hybrid" )
	
	physics.start()
	-- load highscore
	_G.localhighscore = highscore.getHighScore()
end

function setupBackground()
	
	clouds:toBack()
	clouds.x = _W - 50
	clouds.y = 50

	local background = display.newImage("background.png")
	-- fixed background, uncomment to have a dynamic one
	--globalLayer:insert(background)
	background:toBack()
	background.x = _W/2
	background.y = _H/2
	background:scale(1.5, 1.5)
	
end

function setupUI()
	local jumpButton = ui.newButton {
		default = "jump.png",
		onPress = jump
	}

	local fartButton = ui.newButton {
		default = "fart.png",
		onPress = fart
	}

	UILayer:insert(jumpButton)
	UILayer:insert(fartButton)

	jumpButton.x = _W * 1.4
	jumpButton.y = _H - 70
	jumpButton:scale(0.66, 0.66)

	fartButton.x = _W * 1
	fartButton.y = _H - 70
	fartButton:scale(0.66, 0.66)

	local scoreTextLabel = display.newText("SCORE", 0,0, "Komikoz", 24)
	scoreTextLabel:setTextColor(0, 0, 0)
	scoreTextLabel:setReferencePoint(display.TopLeftReferencePoint)
	scoreTextLabel.x = - 180
	scoreTextLabel.y = 0
	
	scoreText = display.newText("0", 0,0, "Komikoz", 24)
	scoreText:setReferencePoint(display.TopLeftReferencePoint)
	scoreText:setTextColor(0, 0, 0)
	scoreText.x = 0
	scoreText.y = 0
	
	local collectableTextLabel = display.newText("FART COINS", 0,0, "Komikoz", 20)
	collectableTextLabel:setTextColor(0, 0, 0)
	collectableTextLabel:setReferencePoint(display.TopRightReferencePoint)
	collectableTextLabel.x = 30
	collectableTextLabel.y = 50
	
	collectableText = display.newText("0", 0,0, "Komikoz", 20)
	collectableText:setReferencePoint(display.TopRightReferencePoint)
	collectableText:setTextColor(0, 0, 0)
	collectableText.x = 100 
	collectableText.y = 50

	UILayer:insert(scoreTextLabel)
	UILayer:insert(scoreText)
	UILayer:insert(collectableTextLabel)
	UILayer:insert(collectableText)

end

function updateCamera()
	globalLayer.x = -skunkInstance.x
	globalLayer.y = -skunkInstance.y + 200
end

function updateScore(score)
	scoreText.text = math.floor(score) - 400
	scoreText.x = 0
	scoreText:setReferencePoint(display.TopLeftReferencePoint)
end

function updateCollectables(count)
	collectableText.text = count
	--collectableText.x = 0
	collectableText:setReferencePoint(display.TopRightReferencePoint)
end

function updateClouds()
	clouds.x = clouds.x - 1;	

	if clouds.x < -800 then
		clouds.x = _W + 800
	end
end

function update()
	skunkInstance.update()
	g:update(skunkInstance.x)
	updateCamera()
	updateScore(skunkInstance.x)
	updateCollectables(skunkInstance.collectableCount)	
	updateClouds()
end

function jump()
	
	if not _G.firstTouch then
		if not _G.gameEnded then
			skunkInstance.jump()
		end
	else
		_G.firstTouch = false
	end
	
end

function fart()
	
	if not _G.firstTouch then
		if not _G.gameEnded then
			skunkInstance.fart()
		end
	else
		_G.firstTouch = false
	end
	
end

function removeListeners()
	Runtime:removeEventListener("enterFrame", update)
end

function new()
	
	init()
	setupBackground()	
	setupUI()

	skunkInstance = skunk.new()
	globalLayer:insert(skunkInstance)
	globalLayer:insert(Collectable.getCollectablesLayer())

	g = ground.new()
	g:setSkunkInstance(skunkInstance)
	g:generate(startPointX, startPointY)
	globalLayer:insert(g)

	Runtime:addEventListener("enterFrame", update)	
	return globalLayer
end