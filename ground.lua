module(..., package.seeall)

local Vector2D = require("vector2d")
local NURBS    = require("nurbs")


local TOTAL_ITERATIONS = 2
local OFFSET = 500
local NURBS_COUNT = 5
local SEGMENT_WIDTH = 600
local SEGMENT_HEIGHT = 100

function new()

	math.randomseed(os.time())

	local self = display.newGroup()		
	self.secondLastY = 0
	self.lastX = 0
	self.lastY = 0
	self.traveled = 0
	self.lastPosX = 400

	--methods
	self.generate = generate
	self.generateNewSegment = generateNewSegment
	self.newSegment = newSegment
	self.update = update

	return self
end

function generate(self, startPointX, startPointY)

	local sx = startPointX
	local sy = startPointY

	self.secondLastY = startPointY
	for i = 1, NURBS_COUNT do
		self:generateNewSegment(sx, sy, sx + SEGMENT_WIDTH, sy + SEGMENT_HEIGHT)
		sx = sx + SEGMENT_WIDTH
		sy = sy + SEGMENT_HEIGHT
	end
end

function generateNewSegment(self, startPointX, startPointY, targetX, targetY)

	local segmentList = {}
	local tempList = {}
	local offsetAmount = OFFSET

	local segment = {sx = startPointX, sy = startPointY, tx = targetX, ty = targetY}
	
	table.insert(segmentList, segment)

	for i = 1, TOTAL_ITERATIONS do
		for j = 1, #segmentList do
			
			local tempSegment = segmentList[j]
			
			local midPointX = tempSegment.sx + (tempSegment.tx - tempSegment.sx) / 2
			local midPointY = tempSegment.sy + (tempSegment.ty - tempSegment.sy) / 2

			local startPtVector = Vector2D:new(tempSegment.sx, tempSegment.sy)
			local endPtVector = Vector2D:new(tempSegment.tx, tempSegment.ty)
			local dirVector = Vector2D:Normalize(Vector2D:Sub(endPtVector, startPtVector))
			local perpendicularVector = Vector2D:Perpendicular(dirVector)
			
			local randomOffset = math.random(-offsetAmount, offsetAmount)
			perpendicularVector:mult(randomOffset)

			midPointX2 = midPointX
			midPointY2 = midPointY + randomOffset

			local segment1 = {sx = tempSegment.sx, sy = tempSegment.sy, tx = midPointX2, ty = midPointY2}
			local segment2 = {sx = midPointX2, sy = midPointY2, tx = tempSegment.tx, ty = tempSegment.ty}

			table.insert(tempList, segment1)
			table.insert(tempList, segment2)
		end
		offsetAmount = offsetAmount / 2

		removeAll(segmentList)
		segmentList = moveAll(tempList)
	end	
	
	local curve = NURBS.new()
	curve:setMaxControlPoints( math.pow(2, TOTAL_ITERATIONS) + 1 )
	self:insert(curve)

	--mirror second y in relation to first point and second to last point of previous segment
	--for continuity	
	segmentList[1].ty = -(self.secondLastY - startPointY)	+ startPointY

	curve:addPoints(segmentList[1].sx, segmentList[1].sy)
	for k = 1, #segmentList do

		local tempSegment = segmentList[k]
		curve:addPoints(tempSegment.tx, tempSegment.ty)
	end

	self.secondLastY = segmentList[#segmentList].sy
	self.lastX = segmentList[#segmentList].tx
	self.lastY = segmentList[#segmentList].ty
			
end

function newSegment(self, controlPoints)
	local curve = NURBS.new()
	curve:setMaxControlPoints( #controlPoints )
	self:insert(curve)

	--mirror second y in relation to first point and second to last point of previous segment
	--for continuity
	controlPoints[2].y = -(self.secondLastY - controlPoints[1].y)	+ controlPoints[1].y

	for i=1,#controlPoints do
		curve:addPoints(controlPoints[i].x, controlPoints[i].y)
	end

	self.secondLastY = controlPoints[#controlPoints - 1].y
	self.lastX = controlPoints[#controlPoints].x
	self.lastY = controlPoints[#controlPoints].y
end

function update(self, posx)
	
	self.traveled = self.traveled + posx - self.lastPosX
	self.lastPosX = posx

	if self.traveled > SEGMENT_WIDTH then
		self:generateNewSegment(self.lastX, self.lastY, self.lastX + SEGMENT_WIDTH, self.lastY + SEGMENT_HEIGHT)
		self:remove(1)
		self.traveled = 0
	elseif self.traveled < -SEGMENT_WIDTH then

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