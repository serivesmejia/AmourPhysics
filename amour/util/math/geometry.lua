local class = require "lib.lua-oop"

local Math = require "amour.util.math"

local Geometry = {}

local Vector2 = class "Vector2"

Geometry.Vector2 = Vector2

Vector2.static.fromOther = function(vector)

    return Vector2:new(nil, nil, vector)

end

function Vector2:constructor(x, y, other)

    if other then
        self.x = other.x
        self.y = other.y
        return
    end

    self:set(x, y)

end

function Vector2:set(x, y)

    if x then
        assert(type(x) == "number", "x is not a number")
        self.x = x
    end

    if y then
        assert(type(y) == "number", "y is not a number")
        self.y = y
    end

end

function Vector2:rotate(rot)

    local angle = 0

    if type(rot) == "table" then
        angle = rot:get()
    else
        angle = rot
    end

    local cosA = math.cos(angle)
    local sinA = math.sin(angle)

    local x  = self.x * cosA - self.y * sinA
    local y = self.x * sinA + self.y * cosA

    self.x = x
    self.y = y

    return self

end

function Vector2:minus(by, y)

    if not by then g = 1 end
    if not y then b = 1 end

    if type(by) == "number" then
        self.x = self.x * by
        self.y = self.y * y
    elseif type(by) == "table" then
        self.x = self.x * by.x
        self.y = self.y * by.y
    end

    return self

end

function Vector2:sum(by, y)

    if not by then g = 1 end
    if not y then b = 1 end

    if type(by) == "number" then
        self.x = self.x + by
        self.y = self.y + y
    elseif type(by) == "table" then
        self.x = self.x + by.x
        self.y = self.y + by.y
    end

    return self

end

function Vector2:subtract(by, y)

    if not by then g = 1 end
    if not y then b = 1 end

    if type(by) == "number" then
        self.x = self.x - by
        self.y = self.y - y
    elseif type(by) == "table" then
        self.x = self.x - by.x
        self.y = self.y - by.y
    end

    return self

end

function Vector2:multiply(by, y)

    if not by then g = 1 end
    if not y then b = 1 end

    if type(by) == "number" then
        self.x = self.x * by
        self.y = self.y * y
    elseif type(by) == "table" then
        self.x = self.x * by.x
        self.y = self.y * by.y
    end

    return self

end

function Vector2:divide(by, y)

    if not by then g = 1 end
    if not y then b = 1 end

    if type(by) == "number" then
        self.x = self.x / by
        self.y = self.y / y
    elseif type(by) == "table" then
        self.x = self.x / by.x
        self.y = self.y / by.y
    end

    return self

end

function Vector2:get()

    return { self.x, self.y }

end

function Vector2:clone()

    return Vector2:new(self.x, self.y)

end

function Vector2:toString()

    return "Vector2(" .. tostring(self.x) .. ", " .. tostring(self.y) .. ")"

end

local Rotation2 = class("Rotation2")
Geometry.Rotation2 = Rotation2

Rotation2.static.fromDegrees = function(deg)
    return Rotation2:new(math.rad(deg))
end

Rotation2.static.fromVector = function(vec, y)

    local pX = 0
    local pY = 0

    if type(vec) == "number" then
        pX = vec
        if not y then
            pY = 0
        end
        pY = y
    else
        pX = vec.x
        pY = vec.y
    end

    local hy = Math.hypot(pX, pY)

    local sin = 0
    local cos = 0

    if hy > 0.00001 then
        sin = y / hy
        cos = x / hy
    else
        sin = 0.0
        cos = 1.0
    end

    return Rotation2:new(math.atan2(sin, cos))

end

function Rotation2:constructor(rad)

    self.rad = rad
    self.cos = math.cos(rad)
    self.sin = math.sin(rad)

end

function Rotation2:get()
    return self.rad
end

function Rotation2:getDegrees()
    return math.deg(self:get())
end

function Rotation2:set(rad)
    self.rad = rad
    self.cos = math.cos(rad)
    self.sin = math.sin(rad)
    return self
end

function Rotation2:setDegrees(deg)
    self:set(math.rad(deg))
    return self
end

function Rotation2:tan()
    return sin / cos
end

function Rotation2:rotate(by)

    local cos = 0
    local sin = 0

    if type(by) == "table" then
        cos = by.cos
        sin = by.sin
    else
        cos = math.cos(by)
        sin = math.sin(by)
    end

    local x = self.cos * cos - self.sin * sin
    local y = self.cos * sin + self.sin * cos

    local hy = Math.hypot(x, y)

    if hy > 0.00001 then
        self.sin = y / hy
        self.cos = x / hy
    else
        self.sin = 0.0
        self.cos = 1.0
    end

    self.rad = math.atan2(self.sin, self.cos)

    return self

end

function Rotation2:invert()
    self:set(-self.rad)
end


function Rotation2:clone()

    return Rotation2:new(self.rad)

end

function Rotation2:toString()

    return "Rotation2(" .. tostring(self.rad) .. ", " .. tostring(self.cos) .. ", " .. tostring(self.sin) .. ")"

end

return Geometry
