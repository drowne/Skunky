module (..., package.seeall)

local fitness
local points

function newGene(controlPoints)
	local gene = {}
	gene.points = controlPoints
	gene.fitness = 0
	return gene
end