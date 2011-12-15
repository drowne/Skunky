module(..., package.seeall)

local Vector2D = require("vector2d")
local NURBS    = require("nurbs")
local GA       = require("geneticalgorithm")

local TOTAL_ITERATIONS = 2
local OFFSET = 500
local NURBS_COUNT = 5
local SEGMENT_WIDTH = 1000
local SEGMENT_HEIGHT = 100
local FRACTAL_GENERATION_COUNT = 10

function new()

	--math.randomseed(os.time())
	math.randomseed(100)

	local self = display.newGroup()
	self.fractalGeneratedPoints = {}
	self.secondLastY = 0
	self.lastX = 0
	self.lastY = 0
	self.traveled = 0
	self.lastPosX = 400
	self.segmentCount = 0
	self.ga = nil
	self.skunkInstance = nil

	-- ga related variables
	self.newGene = nil
	self.oldGene = nil
	self.populationSize = 0
	self.geneIndex = 1

	--methods
	self.generate = generate
	self.generateNewSegment = generateNewSegment
	self.newSegment = newSegment
	self.update = update
	self.newSegmentFromGA = newSegmentFromGA
	self.setSkunkInstance = setSkunkInstance

	return self
end

function setSkunkInstance(self, skunk)
	self.skunkInstance = skunk
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
			
	self.segmentCount = self.segmentCount + 1
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

	self.segmentCount = self.segmentCount + 1
end

function newSegmentFromGA(self)

	local gene = self.ga:getGene(self.geneIndex)

	if self.geneIndex > self.populationSize +2 then
		self.ga:produceNextGeneration()
		self.geneIndex = 1
	else
		self.geneIndex = self.geneIndex + 1
	end

	local cp = gene:getPoints()

	local difX = self.lastX - cp[1].x
	local difY = self.lastY - cp[1].y

	for i=1,#cp do
		cp[i].x = cp[i].x + difX
		cp[i].y = cp[i].y + difY		
	end

	self:newSegment(cp)

	return gene

end

function update(self, posx)
	
	self.traveled = self.traveled + posx - self.lastPosX
	self.lastPosX = posx

	if self.traveled > SEGMENT_WIDTH then
		
		self.traveled = 0
		local curve = self:remove(1)

		if self.segmentCount == FRACTAL_GENERATION_COUNT then
			self.ga = GA.new(self.fractalGeneratedPoints)
			self.populationSize = self.ga:getPopulationSize()
			self.newGene = self:newSegmentFromGA()
		elseif self.segmentCount > FRACTAL_GENERATION_COUNT then
			self.oldGene = self.newGene		
			self.newGene = self:newSegmentFromGA()
			
			-- fitness function
			local vx, vy = self.skunkInstance:getLinearVelocity()
			local speed = math.abs(vx) -- + math.abs(vy)

			self.oldGene:setFitness(speed)
			--print("fitness: " .. speed/_G.NORMALIZINGVALUE)
		else 
			self:generateNewSegment(self.lastX, self.lastY, self.lastX + SEGMENT_WIDTH, self.lastY + SEGMENT_HEIGHT)
			local cp = curve:getControlPoints()

			for i=1,#cp do
				table.insert(self.fractalGeneratedPoints, cp[i])
			end
		end
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