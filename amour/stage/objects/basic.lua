local class = require "lib.lua-oop"
local Geometry = require "amour.util.math.geometry"
local Color = require "amour.util.color"
local StageObject = require "amour.stage.object"

local Basic = {}

-- BASIC SHAPES

local RectangleObj = class("Obj-Rect", StageObject)
Basic.RectangleObj = RectangleObj

function RectangleObj:constructor(position, rotation, size, color)

    StageObject.constructor(self, position, rotation, size, color)

end

function RectangleObj:update(dt)

    self.poly, self.drawPoly = GeometryRect.getRectanglePolygon(self.position, self.rotation, self.size, self.offset)

end

function RectangleObj:draw()

    if not self.drawPoly then
        return 
    end

    local r, g, b, a = self.color:getDecimal()

    love.graphics.push()
    love.graphics.setColor(r, g, b, a)
    love.graphics.polygon("fill", self.drawPoly)
    love.graphics.pop()

end

StaticSpriteObj = class("Obj-StaticSprite", StageObject)
Basic.StaticSpriteObj = StaticSpriteObj

function StaticSpriteObj:constructor(position, rotation, size, color, image)

    StageObject.constructor(self, position, rotation, size, color)

    self.image = image

end

function StaticSpriteObj:init()

    if type(self.image) == "string" then
        self.image = love.graphics.newImage(self.image)
    end

end

function StaticSpriteObj:update()

    self.poly, self.drawPoly = GeometryRect.getRectanglePolygon(self.position, self.rotation, self.size, self.offset)

end

function StaticSpriteObj:draw()

    local r, g, b, a = self.color:getDecimal()

    local scaleX, scaleY = Core.getImageScaleForNewDimensions(self.image, self.size.x, self.size.y)

    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.rotate(self.rotation:get())
    love.graphics.setColor(r, g, b, a)
    love.graphics.draw(self.image, 0 - (self.size.x * self:getOffset()), 0 - (self.size.y * self:getOffset()), nil, scaleX, scaleY)
    love.graphics.pop()

end

function StaticSpriteObj:setOriginalDimensions()

    local w, h = self.image:getDimensions()
    self.size:set(w, h)

end

-- MISCELANEOUS

FpsObj = class("Obj-Fps", StageObject)
Basic.FpsObj = FpsObj

function FpsObj:constructor(position, color)

    StageObject.constructor(self, position, nil, nil, color)

end

function FpsObj:draw()

    love.graphics.push()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    love.graphics.print(tostring(love.timer.getFPS()), self.position.x, self.position.y)
    love.graphics.pop()

end

MouseObj = class("Obj-Mouse", StageObject)
Basic.MouseObj = MouseObj

function MouseObj:constructor()

    StageObject.constructor(self, nil, nil, Geometry.Vector2:new(6, 6), nil)

end

function MouseObj:update()
    self.position:set(love.mouse.getX(), love.mouse.getY())
end

TextObj = class("Obj-Text", StageObject)
Basic.TextObj = TextObj

function TextObj:constructor(position, color, text, fontSize)

    StageObject.constructor(self, position, nil, nil, color)

    if not fontSize then
        fontSize = 12
    end

    if not text then
        text = ""
    end

    self.text = text
    self.fontSize = fontSize

end

function TextObj:draw()

    love.graphics.push()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    love.graphics.setNewFont(self.fontSize)
    love.graphics.print(tostring(self.text), self.position.x, self.position.y)
    love.graphics.pop()

end

return Basic
