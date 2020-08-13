local class = require "lib.lua-oop"

local Behavior = require "amour.stage.behavior"

local BehaviorsPhysics = {}

local RigidBody = class("Behavior-RigidBody", Behavior)
BehaviorsPhysics.RigidBody = RigidBody

function RigidBody:constructor(bodyType, shape, density, radius)

    Behavior.constructor(self)

    if not bodyType then
        bodyType = "dynamic"
    end

    if not shape then
        shape = "rectangle"
    else
        shape = string.lower(shape)
        assert(shape == "rectangle" or shape == "circle", "Shape should be either \"rectangle\" or \"circle\"")
    end

    if not density then
        density = 1
    end

    self.tBodyType = bodyType
    self.tShape = shape
    self.tDensity = density
    self.tRadius = radius

end

function RigidBody:init()

    self.parentObj:setOffset("center") -- when using physics the offset should be in the center always

    local position = self.parentObj.position
    local size = self.parentObj.size
    local radius = 0

    if self.tRadius then
        radius = self.tRadius
    else
        radius = self.parentObj.radius
    end

    self.world = self:getCurrentStage().world
    self.body = love.physics.newBody(self.world, position.x, position.y, self.tBodyType)

    if self.tShape == "rectangle" then
        self.shape = love.physics.newRectangleShape(size.x, size.y)
    elseif self.tShape == "circle" then
        self.shape = love.physics.newCircleShape(radius)
    else
        assert(false, "Shape should be either \"rectangle\" or \"circle\"")
    end

    self.fixture = love.physics.newFixture(self.body, self.shape, self.tDensity)

    self.body:setAngle(self.parentObj.rotation:get())

    self.tBodyType = nil
    self.tShape = nil
    self.tDensity = nil
    self.tRadius = nil

end

function RigidBody:update(dt)

    self.parentObj:setOffset("center") -- when using physics the offset should be in the center always

    local x, y = self.body:getPosition()
    self.parentObj.position:set(x, y)
    self.parentObj.rotation:set(self.body:getAngle())

end

return BehaviorsPhysics
