module (..., package.seeall)

-- limits for the random generation
local limitDownX     = - 100
local limitUpX       = 200
local limitDownY     = - 100
local limitUpY       = 200
local mutationChance = 0.5
local mutationLimit  = 100

new = function(points, fitness)
	
	local self = {}
	
	if points then
		self.points = points
	else
		randomPoints()
	end
	
	self.fitness = fitness or 0

	-- expose methods
	self.randomPoints = randomPoints
	self.mutate       = mutate
	self.reproduce    = reproduce
	self.setPoints    = setPoints
	self.getPoints    = getPoints
	self.setFitness   = setFitness
	self.getFitness   = getFitness

	return self 
end

function randomPoints(self)

	self.points = {}

	for i=1, 5 do

		local point
		point.x = math.random(limitDownX, limitUpX)
		point.y = math.random(limitDownY, limitUpY)

		table.insert(self.points, point)
	end
end

function mutate(self)

	if self.points then

		for i=1, #self.points do
			
			if math.random() < mutationChance then
				self.points[i].y = self.points[i].y + math.random(limitDownY, limitUpY)
			end

		end

	else
		self:randomPoints()
	end

end

function reproduce(self, other)

	local gene1points = {}
	local gene2points = {}

	local cut = math.random( #self.points )

	for i=1, #self.points do
		
		if i < cut then
			table.insert(gene1points, self.points[i])
			table.insert(gene2points, other.points[i])
		else
			table.insert(gene1points, other.points[i])
			table.insert(gene2points, self.points[i])
		end

	end

	local child1 = new(gene1points)
	local child2 = new(gene2points)

	return child1, child2

end

function setPoints(self, newPoints)
	self.points = points
end

function getPoints(self)
	return self.points or {}
end

function setFitness(self, newFitness)
	self.fitness = newFitness
end

function getFitness(self)
	return self.fitness or 0
end