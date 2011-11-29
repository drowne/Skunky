module (..., package.seeall)

local gene = require("gene")

_G.NORMALIZINGVALUE = 1000

new = function(population, populationSize)
	
	local self = {}
	--self.population = population or {}
	self.populationSize = #population or populationSize or 100	
	self.population = {}
	self.populationCount = 0

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
	self.getPopulationSize = getPopulationSize

	return self
end

function getPopulationSize(self)
	return #self.population
end

function produceNextGeneration(self)

	print("producing population #" .. self.populationCount)
	self.populationCount = self.populationCount +1

	for i=1, #self.population do
		local chance = math.random()
		if self.population[i] and self.population[i]:getFitness()/_G.NORMALIZINGVALUE < chance then
			--print("killing an item")
			table.remove(self.population, i)
		end
	end

	-- sort population by fitness
	table.sort( self.population, 

		function(a, b) 
			return a:getFitness() < b:getFitness()
		end
	)

	local killed = self.populationSize - #self.population

	--[[for j=1, killed/2, 2 do
		
		local father = self.population[j]
		local mother = self.population[j+1]

		local child1, child2 = father:reproduce(mother)
		
		table.insert(self.population, child1)
		table.insert(self.population, child2)
	end]]-- offspring generation, doesn't really work

	for j=1, killed do
		local temp = self.population[j]
		temp:mutate()
		table.insert(self.population, temp)
	end

	print("population count: " .. #self.population .. " killed: " .. killed)	

end

function getGene(self, index)

	if index < #self.population then 
		return self.population[index]
	else 
		print( "EXCEPTION: Gene out of population" )
		return self.population[#self.population]
	end
	
end