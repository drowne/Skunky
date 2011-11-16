module (..., package.seeall)

-- limits for the random generation
local limitDownX = - 100
local limitUpX   = 200
local limitDownY = - 100
local limitUpY   = 200

new = function(points, fitness)
	
	local self = {}
	
	self.points = points
	self.fitness = fitness or 0

	return self 
end

function randomPoints(self)

	self.points = {}

	for i, 8 do
		table.insert(self.points, math.random(limitDownX, limitUpX))
		table.insert(self.points, math.random(limitDownY, limitUpY))
	end
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