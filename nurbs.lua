module (..., package.seeall)

local ControlPoint = require("ControlPoint")
local Collectable = require("collectable")

local PRECISION = 30
local Epsilon = 0.00001

local collectableTreshold = 100
local lastCollectable = 0
local collectableCounter = 0
local collectableGroupSize = 20

function new()
    
    local self = display.newGroup()

    --local attributes
    self.numPoints = 0
    self.controlPoints = {}
    self.maxControlPoints = 4
    self.order = 4

    --methods
    self.setMaxControlPoints = setMaxControlPoints
    self.addPoints = addPoints
    self.generateNurbsCurve = generateNurbsCurve
    self.setKnotVector = setKnotVector
    self.defineBasisFunctions = defineBasisFunctions
    self.drawNurbs = drawNurbs
    self.addPoints = addPoints
    self.getControlPoints = getControlPoints

    return self
end

function setMaxControlPoints(self, max)
    self.maxControlPoints = max
end

function generateNurbsCurve (self, precision)

    local points = {}
    local knotVector = self:setKnotVector()
    local nurbsBasisFunctions = self:defineBasisFunctions(precision, knotVector)

    for i  = 1 , precision do            

        local point = {}
        point.x = 0
        point.y = 0
        
        for ctrlPointIndex = 1, self.numPoints do                
            point.x = point.x + self.controlPoints[ctrlPointIndex].x * nurbsBasisFunctions[i][ctrlPointIndex][self.order]
            point.y = point.y + self.controlPoints[ctrlPointIndex].y * nurbsBasisFunctions[i][ctrlPointIndex][self.order]
        end        

        
        table.insert (points, point)
    end

    return points
end

function setKnotVector (self)
    local knots = {}
    local knotValue = 0    

    for i = 0, self.order + self.numPoints - 1 do            
        if (i <= self.numPoints and i >= self.order) then
            knotValue = knotValue + 1
        end
        
        table.insert (knots, knotValue / (self.numPoints - self.order + 1));
    end
    
    return knots;
end

function defineBasisFunctions (self, precision, knotVector)
    local nurbsBasisFunctions = {}
    local basisFunctions = {}

    for j = 1, precision do basisFunctions[j] = {} end
    for j = 1, precision do nurbsBasisFunctions[j] = {} end            

    for vertexIndex = 1, precision do
        
        for j = 1, self.numPoints + 1 do basisFunctions[vertexIndex][j] = {} end
        for j = 1, self.numPoints + 1 do nurbsBasisFunctions[vertexIndex][j] = {} end

        local t = (vertexIndex - 1) / (precision - 1)

        if (t == 1) then t = 1 - Epsilon end

        for ctrlPointIndex = 1, self.numPoints + 1 do
                
            for j = 1, self.numPoints + 1 do basisFunctions[vertexIndex][ctrlPointIndex][j] = 0 end
            for j = 1, self.numPoints + 1 do nurbsBasisFunctions[vertexIndex][ctrlPointIndex][j] = 0 end

            if (t >= knotVector[ctrlPointIndex] and t < knotVector[ctrlPointIndex + 1]) then
                basisFunctions[vertexIndex][ctrlPointIndex][1] = 1
            else
                basisFunctions[vertexIndex][ctrlPointIndex][1] = 0
            end            
        end
    end    

    for orderIndex = 2, self.order do
            
        for ctrlPointIndex = 1, self.numPoints do
                
            for vertexIndex = 1, precision do
                    
                local t = (vertexIndex - 1) / (precision - 1);

                local Nikm1 = basisFunctions[vertexIndex][ctrlPointIndex][orderIndex - 1];
                local Nip1km1 = basisFunctions[vertexIndex][ctrlPointIndex + 1][orderIndex - 1];

                local xi = knotVector[ctrlPointIndex];
                local xikm1 = knotVector[ctrlPointIndex + orderIndex - 1];
                local xik = knotVector[ctrlPointIndex + orderIndex];
                local xip1 = knotVector[ctrlPointIndex + 1];                

                local FirstTermBasis;
                if (math.abs(xikm1 - xi) < Epsilon) then
                    FirstTermBasis = 0;
                else
                    FirstTermBasis = ((t - xi) * Nikm1) / (xikm1 - xi);
                end

                local SecondTermBasis;
                if (math.abs(xik - xip1) < Epsilon) then
                    SecondTermBasis = 0;
                else
                    SecondTermBasis = ((xik - t) * Nip1km1) / (xik - xip1);
                end

                basisFunctions[vertexIndex][ctrlPointIndex][orderIndex] = FirstTermBasis + SecondTermBasis;                
            end
        end
    end

    for orderIndex = 2, self.order do
            
        for ctrlPointIndex = 1, self.numPoints do
                
            for vertexIndex = 1, precision do
                    
                local denominator = 0;
                for controlWeight = 1, self.numPoints do
                        
                    denominator = denominator + self.controlPoints[controlWeight].weight * basisFunctions[vertexIndex][controlWeight][orderIndex];
                end

                nurbsBasisFunctions[vertexIndex][ctrlPointIndex][orderIndex] = self.controlPoints[ctrlPointIndex].weight *
                                                                           basisFunctions[vertexIndex][ctrlPointIndex][orderIndex] /
                                                                           denominator;                
            end
        end
    end

    return nurbsBasisFunctions;

end

function drawNurbs (self, precision)
    local points = self:generateNurbsCurve (precision)

    for i = 1, precision-1 do 
        local line = display.newLine(points[i].x, points[i].y, points[i + 1].x, points[i + 1].y);
        line:setColor(255, 0, 0);
        line.width = 5;        

        -- physic body
        local xDist = (points[i+1].x - points[i].x)
        local yDist = (points[i+1].y - points[i].y)
        local lineShape = { 0, 0, xDist, yDist, --xDist,yDist+20, -xDist,-yDist+20 
        }

        if points[i].x > lastCollectable + collectableTreshold then
            lastCollectable = points[i].x
            placeNewCollectable(points[i].x, points[i].y - 50)
            collectableCounter = collectableCounter + 1

            if collectableCounter % collectableGroupSize == 0 then
                collectableTreshold = 1000
            else
                collectableTreshold = 100
            end
        end
        
        physics.addBody(line, "static",  { shape = lineShape} )

        self:insert( line )
    end 
end

function placeNewCollectable(x, y)
    Collectable.new(x, y)
end

function addPoints (self, _x, _y)
    
    self.numPoints = self.numPoints + 1;

    local point = ControlPoint.new()
    point.x = _x
    point.y = _y

    table.insert (self.controlPoints, point)

    --local rect = display.newRect(point.x, point.y, 15, 15)
    --self:insert(rect) 

    if(self.numPoints >= self.maxControlPoints) then
        self:drawNurbs(30)
    end
end

function getControlPoints(self)
    local cp = {}

    for i=1,#self.controlPoints do
        local point = {}
        point.x = self.controlPoints[i].x
        point.y = self.controlPoints[i].y
        table.insert(cp, point)
    end

    return cp
end