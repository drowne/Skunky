module(..., package.seeall)

local Vector2D = require("vector2d")

function newGround(startPointX, startPointY, targetX, targetY, parent)

	local segmentList = display.newGroup()

	if (parent ~= nil) then
		parent:insert(segmentList)
	end	

	local MAIN_LIGHTNING_WIDTH = 3	
	local TOTAL_ITERATIONS = 3	
	
	local segment = display.newLine(startPointX,startPointY, targetX, targetY)
	segment.x1 = startPointX
	segment.y1 = startPointY
	segment.x2 = targetX
	segment.y2 = targetY

	local red = 255
	local green = 0
	local blue = 0
	
	segment:setColor(red, green, blue)
	segment.width = MAIN_LIGHTNING_WIDTH
	segmentList:insert(segment)
	
	offsetAmount = 200

	local segmentIndex = 1

	for i=1,TOTAL_ITERATIONS do
		for j=1,segmentList.numChildren do
			local tempSegment = segmentList[segmentIndex]

			local midPointX = tempSegment.x1 + (tempSegment.x2 - tempSegment.x1)/2
			local midPointY = tempSegment.y1 + (tempSegment.y2 - tempSegment.y1)/2

			local startPtVector = Vector2D:new(tempSegment.x1,tempSegment.y1)
			local endPtVector = Vector2D:new(tempSegment.x2,tempSegment.y2)

			local dirVector = Vector2D:Normalize(Vector2D:Sub(endPtVector,startPtVector))

			local perpendicularVector = Vector2D:Perpendicular(dirVector)

			math.randomseed(os.time() * j)
			local randomOffset = math.random(-offsetAmount,offsetAmount)
			perpendicularVector:mult(randomOffset)

			midPointX2 = midPointX + perpendicularVector.x
			midPointY2 = midPointY + perpendicularVector.y

			local segment1 = display.newLine(tempSegment.x1,tempSegment.y1, midPointX2, midPointY2)
			segment1.x1 = tempSegment.x1
			segment1.y1 = tempSegment.y1
			segment1.x2 = midPointX2
			segment1.y2 = midPointY2
			segment1:setColor(red, green, blue,255)
			segment1.width = MAIN_LIGHTNING_WIDTH

			local segment2 = display.newLine(midPointX2, midPointY2, tempSegment.x2, tempSegment.y2)
			segment2.x1 = midPointX2
			segment2.y1 = midPointY2
			segment2.x2 = tempSegment.x2
			segment2.y2 = tempSegment.y2
			segment2:setColor(red, green, blue,255)
			segment2.width = MAIN_LIGHTNING_WIDTH

			tempSegment:removeSelf()
			segmentList:remove(tempSegment)
			segmentList:insert(segment1)
			segmentList:insert(segment2)
		end
		offsetAmount = offsetAmount / 2
	end			
end