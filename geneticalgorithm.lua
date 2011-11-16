module (..., package.seeall)

local gene = require("gene")

new = function(population, populationSize)
	
	local self = {}
	self.population = population or {}
	self.populationSize = #population or populationSize

	print(self.populationSize)

	-- initialize population
	for i, self.populationSize do
		self.population[i]:randomPoints()
	end

	return self
end

function produceNextGeneration(self)

	for i, self.populationSize do
		local chance = math.random()
		if self.population[i]:getFitness() < chance then
			table.remove(self.population, i)
		end
	end

	local killed = self.populationSize - #self.population
	-- introduce here offspring generation or something else

	for j, killed do
		local temp = gene.new()
		temp:randomPoints()
		table.insert(self.population, temp)
	end

end

function getGene(self, index)
	return self.population[index]
end