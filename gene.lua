module (..., package.seeall)

function newGene(controlPoints)
	local gene = {}
	gene.points = controlPoints
	gene.fitness = 0
	return gene
end