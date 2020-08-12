require "amour.util"

local HitboxUtil = {}

function HitboxUtil.doPolygonsIntersect(a, b)

    local polygons = { a, b };
    local minA, maxA, projected, i, i1, j, minB, maxB;

    for i = 1, #polygons do
        --// for each polygon, look at each edge of the polygon, and determine if it separates
        --// the two shapes
        local polygon = polygons[i];
        for i1 = 0, (#polygon-1) do
            --// grab 2 vertices to create an edge
            local i2 = (i1 + 1) % (#polygon);
            local p1 = polygon[i1+1];
            local p2 = polygon[i2+1];

            --// find the line perpendicular to this edge
            local normal = { x = p2.y - p1.y, y = p1.x - p2.x };
            minA = nil;
            maxA = nil;

            --// for each vertex in the first shape, project it onto the line perpendicular to the edge
            --// and keep track of the min and max of these values
            for j = 1, #a do
                projected = normal.x * a[j].x + normal.y * a[j].y;
                if (minA == nil or projected < minA) then
                    minA = projected;
                end
                if (maxA == nil or projected > maxA) then
                    maxA = projected;
                end
            end

            --// for each vertex in the second shape, project it onto the line perpendicular to the edge
            --// and keep track of the min and max of these values
            minB = nil;
            maxB = nil;
            for j = 1, #b do
                projected = normal.x * b[j].x + normal.y * b[j].y;
                if (minB == nil or projected < minB) then
                    minB = projected;
                end
                if (maxB == nil or projected > maxB) then
                    maxB = projected;
                end
            end

            if (maxA < minB or maxB < minA) then
                return false;
            end
        end
    end

    return true;
end

return HitboxUtil
