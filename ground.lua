module(..., package.seeall)

local Vector2D = require("vector2d")
local nurbs    = require("nurbs")

local globalLayer = display.newGroup()

local TOTAL_ITERATIONS = 5	

function initialize()
	globalLayer:insert(nurbs.new())
	nurbs.setControlPointNum( math.pow(2, TOTAL_ITERATIONS) )
	return globalLayer
end

function getGlobalLayer()
	return globalLayer
end

function addPoints(_x, _y)
	nurbs.addPoints(_x, _y)
end

function newGround(startPointX, startPointY, targetX, targetY, parent)

	local segmentList = {}
	local offsetAmount = 300

	local segment = {startPointX, startPointY, targetX, targetY}

	table.insert(segmentList, segment)

	local segmentIndex = 1

	for i=1, TOTAL_ITERATIONS do
		for j=1, #segmentList do
			
			local tempSegment = segmentList[segmentIndex]
			
			local midPointX = tempSegment[1] + (tempSegment[3] - tempSegment[1])/2
			local midPointY = tempSegment[2] + (tempSegment[4] - tempSegment[2])/2

			local startPtVector = Vector2D:new(tempSegment[1],tempSegment[2])
			local endPtVector = Vector2D:new(tempSegment[3],tempSegment[4])
			local dirVector = Vector2D:Normalize(Vector2D:Sub(endPtVector,startPtVector))
			local perpendicularVector = Vector2D:Perpendicular(dirVector)

			math.randomseed(os.time() * j)
			local randomOffset = math.random(-offsetAmount,offsetAmount)
			perpendicularVector:mult(randomOffset)

			midPointX2 = midPointX
			midPointY2 = midPointY + randomOffset

			local segment1 = {tempSegment[1],tempSegment[2], midPointX2, midPointY2}
			local segment2 = {midPointX2, midPointY2, tempSegment[3], tempSegment[4]}

			table.remove(segmentList, 1)
			table.insert(segmentList, segment1)
			table.insert(segmentList, segment2)
		end
		offsetAmount = offsetAmount / 2
	end	
	


	for z=1, #segmentList do

		local tempSegment = segmentList[z]
		addPoints(tempSegment[1], tempSegment[2])

	end
			
end
