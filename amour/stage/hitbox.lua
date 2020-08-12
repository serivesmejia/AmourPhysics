local class = require "lib.lua-oop"

local HitboxUtil = require "amour.stage.hitbox.util"

require "amour.util"

local Hitbox = class("Hitbox")

function Hitbox:constructor(params, type)

    self.params = params

    self:setType(type)

end

function Hitbox:isHitting(other)

    local lowerType = string.lower(self.type)

    if lowerType == "axisaligned" then

        local position = self.params.position
        local size = self.params.size
        other = other.params
        
        return position.x < other.position.x + other.size.x and
               other.position.x < position.x + size.x and
               position.y < other.position.y + other.size.y and
               other.position.y < position.y + size.y

    elseif lowerType == "rotated" then

        if not self.params.poly or not other.params.poly then
            return false
        end

        return HitboxUtil.doPolygonsIntersect(self.params.poly, other.params.poly)

    end

end

function Hitbox:setType(type)

    if not type then
        type = "axisaligned"
    end

    local lowerType = string.lower(type)

    if (lowerType == "axisaligned") or (lowerType == "rotated") then
        self.type = lowerType
    end

end

return Hitbox
