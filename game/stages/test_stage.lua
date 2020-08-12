local class = require "lib.lua-oop"
local Stage = require "amour.stage"

local test_stage = class("Stage-Template", Stage)

function test_stage:constructor(stageManager)

    Stage.constructor(self, stageManager) -- don't forget to call superclass constructor

end

function test_stage:init()

    Core.setBackgroundColor(0, 0, 0, 255) -- recommended to set bg color here

    self.rectA = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(200, 200), nil, Geometry.Vector2:new(50, 100), Color:new(0, 0, 255, 255))
    self:addObject(self.rectA)
    self.rARigidBody = BehaviorsPhysics.RigidBody("dynamic", 1)
    self.rectA:attachBehavior(self.rARigidBody)
    self.rARigidBody.fixture:setRestitution(0.5)

    self.rectB = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(100, 200), nil, Geometry.Vector2:new(50, 100), Color:new(0, 255, 0, 255))
    self:addObject(self.rectB)
    self.rBRigidBody = BehaviorsPhysics.RigidBody("dynamic", 1)
    self.rectB:attachBehavior(self.rBRigidBody)
    self.rBRigidBody.fixture:setRestitution(0.5)

    self.rectC = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(love.graphics.getWidth()/2, 600), nil, Geometry.Vector2:new(800, 100), Color:new(127, 127, 127, 255))
    self:addObject(self.rectC)
    self.rectC:attachBehavior(BehaviorsPhysics.RigidBody("static", 1))

    self.rectD = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(0, 600), nil, Geometry.Vector2:new(5, 1200), Color:new(127, 127, 127, 255))
    self:addObject(self.rectD)
    self.rectD:attachBehavior(BehaviorsPhysics.RigidBody("static", 1))

    self.rectE = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(800, 600), nil, Geometry.Vector2:new(5, 1200), Color:new(127, 127, 127, 255))
    self:addObject(self.rectE)
    self.rectE:attachBehavior(BehaviorsPhysics.RigidBody("static", 1))

    self.rectF = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(0, 0), nil, Geometry.Vector2:new(4000, 8), Color:new(127, 127, 127, 255))
    self:addObject(self.rectF)
    self.rectF:attachBehavior(BehaviorsPhysics.RigidBody("static", 1))

    self:addObject(ObjectsBasic.FpsObj:new())

    self.upPressed = true

end

function test_stage:update(dt)

    if love.keyboard.isDown("left") then
        self.rARigidBody.body:applyForce(-400, 0)
    elseif love.keyboard.isDown("right") then
        self.rARigidBody.body:applyForce(400, 0)
    elseif love.keyboard.isDown("up") then
        if not self.upPressed then
            self.upPressed = true
            self.rARigidBody.body:applyLinearImpulse(0, -500)
        end
    else
        self.upPressed = false
    end

    self.world:update(dt)

end

function test_stage:draw()

    -- draw code here

end


return test_stage -- don't forget to return the stage class
