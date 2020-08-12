GeometryUtil = {}

function GeometryUtil.getRectangleCenter(position, size, off)

    local x = 0
    local y = 0
    if not off or string.lower(off) == "center" then
        x = position.x
        y = position.y
    elseif string.lower(off) == "corner" then
        x = position.x + (size.x / 2)
        y = position.y + (size.y / 2)
    else
        assert(false, "Offset should be either \"center\" or \"corner\"")
    end

    return { x = x, y = y }

end

function GeometryUtil.getRotRectangleCenter(position, rotation, size, offset)

    local center = GeometryUtil.getRectangleCenter(position, offset)
    local angle = rotation:get()

    local vec = { x = center.x - position.x + size.x / 2, y = center.y - position.y + size.y / 2 }

    local cosA = math.cos(angle)
    local sinA = math.sin(angle)

    local x  = vec.x * cosA - vec.y * sinA
    local y = vec.x * sinA + vec.y * cosA

    return { x = x + position.x, y = y + position.y }

end

function GeometryUtil.getRectangleCorner(position, size, off)

    local offset = 0

    local x = 0
    local y = 0

    if not off or string.lower(off) == "center" then
        x = position.x - (size.x / 2)
        y = position.y - (size.y / 2)
    elseif string.lower(off) == "corner" then
        x = position.x - (size.x / 2)
        y = position.y - (size.y / 2)
    else
        assert(false, "Offset should be either \"center\" or \"corner\"")
    end

    return { x = x, y = y }

end

function GeometryUtil.getRectanglePolygon(position, rotation, size, offset)

    if not offset then
        offset = "center"
    end

    local center = nil
    local lowerOffset = string.lower(offset)

    if lowerOffset == "center" then
        center = GeometryUtil.getRectangleCenter(position, offset)
    elseif lowerOffset == "corner" then
        center = GeometryUtil.getRotRectangleCenter(position, rotation, size, offset)
    else
        assert(false, "Offset should be either \"center\" or \"corner\"")
    end

    local angle = rotation:get()
    local width = size.x
    local height = size.y

    local cos = math.cos
    local sin = math.sin

    local polygon = {}
    local drawablePoly = {}

    local x = center.x - ((width / 2) * cos(angle)) - ((height / 2) * sin(angle))
    local y = center.y - ((width / 2) * sin(angle)) + ((height / 2) * cos(angle))
    table.insert(polygon, {x=x, y=y})
    table.insert(drawablePoly, x)
    table.insert(drawablePoly, y)

    x = center.x - ((width / 2) * cos(angle)) + ((height / 2) * sin(angle))
    y = center.y - ((width / 2) * sin(angle)) - ((height / 2) * cos(angle))
    table.insert(polygon, {x=x, y=y})
    table.insert(drawablePoly, x)
    table.insert(drawablePoly, y)

    x = center.x + ((width / 2) * cos(angle)) + ((height / 2) * sin(angle))
    y = center.y + ((width / 2) * sin(angle)) - ((height / 2) * cos(angle))
    table.insert(polygon, {x=x, y=y})
    table.insert(drawablePoly, x)
    table.insert(drawablePoly, y)

    x = center.x + ((width / 2) * cos(angle)) - ((height / 2) * sin(angle))
    y = center.y + ((width / 2) * sin(angle)) + ((height / 2) * cos(angle))
    table.insert(polygon, {x=x, y=y})
    table.insert(drawablePoly, x)
    table.insert(drawablePoly, y)

    return polygon, drawablePoly

end

function GeometryUtil.toDrawablePolygon(poly)

    local drawablePoly = {}

    for k in pairs(poly) do
        if type(poly[k]) == "table" then
            table.insert(drawablePoly, poly[k].x)
            table.insert(drawablePoly, poly[k].y)
        end
    end

    return drawablePoly

end

return GeometryUtil
