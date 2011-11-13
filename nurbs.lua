module (..., package.seeall)

local ControlPoint = require("ControlPoint")

local generated = FALSE
local numPoints = 0
local controlPoints = {}
local order = 4
local Epsilon = 0.00001
local gControlPoints
local controlPointsNum

function setControlPointNum(newOrder)
	controlPointsNum = newOrder
end

function newNurbsCurve (precision)

	local points = {}
	local knotVector = setKnotVector ()
	local nurbsBasisFunctions = defineBasisFunctions (precision, knotVector)

	for i  = 1 , precision do            

        local point = {}
        point.x = 0
        point.y = 0
        
        for ctrlPointIndex = 1, numPoints do                
            point.x = point.x + controlPoints[ctrlPointIndex].x * nurbsBasisFunctions[i][ctrlPointIndex][order];
            point.y = point.y + controlPoints[ctrlPointIndex].y * nurbsBasisFunctions[i][ctrlPointIndex][order];            
        end        

        
        table.insert (points, point)
    end

    return points
end

function setKnotVector ()
	local knots = {}
    local knotValue = 0    

    for i = 0, order + numPoints - 1 do            
        if (i <= numPoints and i >= order) then
            knotValue = knotValue + 1
        end
        
        table.insert (knots, knotValue / (numPoints - order + 1));
    end
    
    return knots;
end

function defineBasisFunctions (precision, knotVector)
	local nurbsBasisFunctions = {}
    local basisFunctions = {}

    for j = 1, precision do basisFunctions[j] = {} end
    for j = 1, precision do nurbsBasisFunctions[j] = {} end            

    for vertexIndex = 1, precision do
        
     	for j = 1, numPoints + 1 do basisFunctions[vertexIndex][j] = {} end
       	for j = 1, numPoints + 1 do nurbsBasisFunctions[vertexIndex][j] = {} end

        local t = (vertexIndex - 1) / (precision - 1)

        if (t == 1) then t = 1 - Epsilon end

        for ctrlPointIndex = 1, numPoints + 1 do
            	
           	for j = 1, numPoints + 1 do basisFunctions[vertexIndex][ctrlPointIndex][j] = 0 end
       		for j = 1, numPoints + 1 do nurbsBasisFunctions[vertexIndex][ctrlPointIndex][j] = 0 end

            if (t >= knotVector[ctrlPointIndex] and t < knotVector[ctrlPointIndex + 1]) then
                basisFunctions[vertexIndex][ctrlPointIndex][1] = 1
            else
                basisFunctions[vertexIndex][ctrlPointIndex][1] = 0
            end            
        end
    end    

    for orderIndex = 2, order do
            
        for ctrlPointIndex = 1, numPoints do
                
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

    for orderIndex = 2, order do
            
        for ctrlPointIndex = 1, numPoints do
                
            for vertexIndex = 1, precision do
                    
                local denominator = 0;
                for controlWeight = 1, numPoints do
                        
        	        denominator = denominator + controlPoints[controlWeight].weight * basisFunctions[vertexIndex][controlWeight][orderIndex];
    	        end

                nurbsBasisFunctions[vertexIndex][ctrlPointIndex][orderIndex] = controlPoints[ctrlPointIndex].weight *
                                                                           basisFunctions[vertexIndex][ctrlPointIndex][orderIndex] /
                                                                           denominator;                
            end
        end
    end

    return nurbsBasisFunctions;

end

function drawNurbs (precision)
	local points = newNurbsCurve (precision)

	for i = 1, precision - 1, 1 do 
		local line = display.newLine(points[i].x, points[i].y, points[i + 1].x, points[i + 1].y);
		line:setColor(255, 0, 0);
		line.width = 5;
		gControlPoints:insert( line )
	end 
end


function addPoints (_x, _y)
	
	numPoints = numPoints + 1;
	local point = ControlPoint.new()
	point.x = _x
	point.y = _y

	table.insert (controlPoints, point);

	local rect = display.newRect(point.x, point.y, 15, 15)
	gControlPoints:insert(rect)	

	if(numPoints >= controlPointsNum) then
		drawNurbs(30)
	end
end

function new()
	gControlPoints = display.newGroup()

	return gControlPoints
end