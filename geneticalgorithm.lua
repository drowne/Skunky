module (..., package.seeall)

local gene = require("gene")

new = function(population, populationSize)
	
	local self = {}
	--self.population = population or {}
	self.populationSize = #population or populationSize or 100	
	self.population = {}

	if population then
		for z=1, #population, 5 do

			local temp = {}
			table.insert(temp, population[z])
			table.insert(temp, population[z+1])
			table.insert(temp, population[z+2])
			table.insert(temp, population[z+3])
			table.insert(temp, population[z+4])			

			table.insert(self.population, gene.new(temp))
		end
	else
		-- initialize population
		for i=1, self.populationSize do
			self.population[i]:randomPoints()
		end
	end

	self.produceNextGeneration = produceNextGeneration
	self.getGene = getGene

	return self
end

function produceNextGeneration(self)

	for i=1, #self.population do
		local chance = math.random()
		if self.population[i] and self.population[i]:getFitness() < chance then
			--print("killing an item")
			table.remove(self.population, i)
		end
	end

	local killed = self.populationSize - #self.population

	for j=1, killed/2, 2 do
		
		local father = self.population[j]
		local mother = self.population[j+1]

		local child1, child2 = father:reproduce(mother)
		
		table.insert(self.population, child1)
		table.insert(self.population, child2)
	end

end

function getGene(self, index)
	return self.population[index]
end