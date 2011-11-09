module (..., package.seeall)

local director 	= require ("director")
local ui		= require("ui")
local easyfb 	= require("easyfb")

local globalLayer = display.newGroup()

local _H = display.contentHeight
local _W = display.contentWidth

function playGame()
	director:changeScene("level1", "fade")
end

function facebook()
	
	local messageTopost = "I'm playing Skunky - The Flying Skunk on my iPhone! Download it from the appStore and beat my highscore!"
	easyfb.publishOnFacebook(messageTopost)
end

function new()
	
	local background = display.newImage("background.png")
	globalLayer:insert(background)
	background.x = _W/2
	background.y = _H/2
	background:scale(1.5, 1.5)
	
	local title = display.newImage("title.png")
	title.x = _W/2
	title.y = _H/2 - 100
	
	globalLayer:insert(title)
	
	local playButton = ui.newButton {
		default = "playoff.png",
		onPress = playGame
	}
	
	local fbButton = ui.newButton {
		default = "fboff.png",
		over = "fbon.png",
		onPress = facebook
	}
	
	globalLayer:insert(playButton)
	globalLayer:insert(fbButton)
	
	playButton.x = _W/2
	playButton.y = _H/2 + 110
	playButton:scale(1.3, 1.3)
	
	fbButton.x = _W + 140
	fbButton.y = _H - 50
	--fbButton:scale(1.3, 1.3)
	
	return globalLayer
end