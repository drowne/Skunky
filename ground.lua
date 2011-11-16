module(..., package.seeall)

local Vector2D = require("vector2d")
local nurbs    = require("nurbs")

local globalLayer = display.newGroup()

local TOTAL_ITERATIONS = 2	

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
	local tempList = {}
	local offsetAmount = 500

	local segment = {startPointX, startPointY, targetX, targetY}

	math.randomseed(os.time())
	table.insert(segmentList, segment)

	local segmentIndex = 1

	for i=1, TOTAL_ITERATIONS do
		for j=1, #segmentList do
			
			local tempSegment = segmentList[j]
			
			local midPointX = tempSegment[1] + (tempSegment[3] - tempSegment[1])/2
			local midPointY = tempSegment[2] + (tempSegment[4] - tempSegment[2])/2

			local startPtVector = Vector2D:new(tempSegment[1],tempSegment[2])
			local endPtVector = Vector2D:new(tempSegment[3],tempSegment[4])
			local dirVector = Vector2D:Normalize(Vector2D:Sub(endPtVector,startPtVector))
			local perpendicularVector = Vector2D:Perpendicular(dirVector)
			
			local randomOffset = math.random(-offsetAmount,offsetAmount)
			perpendicularVector:mult(randomOffset)

			midPointX2 = midPointX
			midPointY2 = midPointY + randomOffset

			local segment1 = {tempSegment[1],tempSegment[2], midPointX2, midPointY2}
			local segment2 = {midPointX2, midPointY2, tempSegment[3], tempSegment[4]}

			table.insert(tempList, segment1)
			table.insert(tempList, segment2)
		end
		offsetAmount = offsetAmount / 2

		removeAll(segmentList)
		segmentList = moveAll(tempList)
	end	
	


	for z=1, #segmentList do

		local tempSegment = segmentList[z]
		addPoints(tempSegment[1], tempSegment[2])

	end
			
end

function removeAll(array)

	for j = 1, #array do
		table.remove(array)
	end
end

function moveAll(source)
	local destination = {}
	
	for j = 1, #source do
		local segment = table.remove(source, 1)
		table.insert(destination, segment)
	end

	return destination
end