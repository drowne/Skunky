module (..., package.seeall)

-- limits for the random generation
local limitDownX = - 100
local limitUpX   = 200
local limitDownY = - 100
local limitUpY   = 200

new = function(points, fitness)
	
	local self = {}
	
	if points then
		self.points = points
	else
		randomPoints()
	end
	
	self.fitness = fitness or 0

	return self 
end

function randomPoints(self)

	self.points = {}

	for i=1, 5 do
		table.insert(self.points, math.random(limitDownX, limitUpX))
		table.insert(self.points, math.random(limitDownY, limitUpY))
	end
end

function reproduce(self, other)

	local gene1points = {}
	local gene2points = {}

	local cut = math.random( self.points.size )

	for i=1, self.points.size do
		
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
	return self.points
end

function setFitness(self, newFitness)
	self.fitness = newFitness
end

function getFitness(self)
	return self.fitness
end