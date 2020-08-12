local class = require "lib.lua-oop"

local Behavior = require "amour.stage.behavior"

local BehaviorsPhysics = {}

local RigidBody = class("Behavior-RigidBody", Behavior)
BehaviorsPhysics.RigidBody = RigidBody

function RigidBody:constructor(bodyType, density)

    Behavior.constructor(self)

    if not bodyType then
        bodyType = "dynamic"
    end

    if not density then
        density = 1
    end

    self.tBodyType = bodyType
    self.tDensity = density

end

function RigidBody:init()

    self.parentObj:setOffset("center") -- when using physics the offset should be in the center always

    local position = self.parentObj.position
    local size = self.parentObj.size

    self.world = self:getCurrentStage().world
    self.body = love.physics.newBody(self.world, position.x, position.y, self.tBodyType)
    self.shape = love.physics.newRectangleShape(size.x, size.y)
    self.fixture = love.physics.newFixture(self.body, self.shape, self.tDensity)

    self.body:setAngle(self.parentObj.rotation:get())

    self.tBodyType = nil
    self.tDensity = nil

end

function RigidBody:update(dt)

    self.parentObj:setOffset("center") -- when using physics the offset should be in the center always

    local x, y = self.body:getPosition()
    self.parentObj.position:set(x, y)
    self.parentObj.rotation:set(self.body:getAngle())

end

return BehaviorsPhysics
