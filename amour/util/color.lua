local class = require "lib.lua-oop"

local Math = require "amour.util.math"

local Color = class "Color"

Color.static.fromBackgroundColor = function() -- LOVE2D framework

    local r, g, b, a = love.graphics.getBackgroundColor()

    return Color:new(r*255, g*255, b*255, a*255)

end

Color.static.fromRandom = function()

    return Color:new(math.random()*255, math.random()*255, math.random()*255, math.random()*255)

end

function Color:constructor(r, g, b, a)

    self:set(r, g, b, a)

    self:clip()

end

function Color:invert()

    self.r = 255 - self.r

    self.g = 255 - self.g

    self.b = 255 - self.b

    return self:clip()

end

function Color:sum(o, g, b, a)

    if not o then o = 1 end
    if not g then g = 1 end
    if not b then b = 1 end
    if not a then a = 1 end

    if type(other) == "table" then
        self.r = self.r + o.r
        self.g = self.g + o.g
        self.b = self.b + o.b
        self.a = self.a + o.a
    elseif type(other) == "number" then
        self.r = self.r + o
        self.g = self.g + g
        self.b = self.b + b
        self.a = self.a + a
    end

    self:clip()

    return self

end

function Color:subtract(o, g, b, a)

    if not o then o = 1 end
    if not g then g = 1 end
    if not b then b = 1 end
    if not a then a = 1 end

    if type(other) == "table" then
        self.r = self.r - o.r
        self.g = self.g - o.g
        self.b = self.b - o.b
        self.a = self.a - o.a
    elseif type(other) == "number" then
        self.r = self.r - o
        self.g = self.g - g
        self.b = self.b - b
        self.a = self.a - a
    end

    self:clip()

    return self

end

function Color:multiply(o, g, b, a)

    if not o then o = 1 end
    if not g then g = 1 end
    if not b then b = 1 end
    if not a then a = 1 end

    if type(other) == "table" then
        self.r = self.r * o.r
        self.g = self.g * o.g
        self.b = self.b * o.b
        self.a = self.a * o.a
    elseif type(other) == "number" then
        self.r = self.r * o
        self.g = self.g * g
        self.b = self.b * b
        self.a = self.a * a
    end

    self:clip()

    return self

end

function Color:divide(o, g, b, a)

    if not o then o = 1 end
    if not g then g = 1 end
    if not b then b = 1 end
    if not a then a = 1 end

    if type(other) == "table" then
        self.r = self.r / o.r
        self.g = self.g / o.g
        self.b = self.b / o.b
        self.a = self.a / o.a
    elseif type(other) == "number" then
        self.r = self.r / o
        self.g = self.g / g
        self.b = self.b / b
        self.a = self.a / a
    end

    self:clip()

    return self

end

function Color:clip()

    -- Improve performance by storing frequent
    -- function in a local variable
    local clipLoc = Math.clip

    self.r = clipLoc(self.r, 0, 255)
    self.g = clipLoc(self.g, 0, 255)
    self.b = clipLoc(self.b, 0, 255)
    self.a = clipLoc(self.a, 0, 255)

    return self

end

function Color:set(r, g, b, a)

    -- if first parameter is an object
    -- hopefully another color...
    if type(r) == "table" then
        local col = r
        self.r = col.r
        self.g = col.g
        self.b = col.b
        self.a = col.a
        return
    end

    if r then
        self.r = r
    else
        self.r = 0
    end

    if g then
        self.g = g
    else
        self.g = 0
    end

    if b then
        self.b = b
    else
        self.b = 0
    end

    if a then
        self.a = a
    else
        self.a = 255
    end

    return self

end

function Color:setFromBackground()

    local r, g, b, a = love.graphics.getBackgroundColor()

    self:set(r*255, g*255, b*255, a*255)

    return self

end

function Color:clone()

    return Color:new(self.r, self.g, self.b, self.a)

end


function Color:get()

    return { self.r, self.g, self.b, self.a }

end

function Color:getDecimal()

    return { self.r / 255, self.g / 255, self.b / 255, self.a / 255 }

end

function Color:toString()

    local str = "(" .. tostring(self.r) .. ", " .. tostring(self.g) .. ", " .. tostring(self.b) .. ", " .. tostring(self.a) .. ")"

    return "Color" .. str

end

return Color
