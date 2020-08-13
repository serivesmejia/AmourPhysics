local class = require "lib.lua-oop"
local Stage = require "amour.stage"

local level_stage = class("Stage-Level", Stage)

function level_stage:constructor(pathToLevel)

    Stage.constructor(self) -- don't forget to call superclass constructor

    print (pathToLevel)

    if not pathToLevel then
        pathToLevel = "game.levels.level_1"
    end

    assert(type(pathToLevel) == "string", "Path to level should be a string")

    self.pathToLevel = pathToLevel

end

function level_stage:init()

    Core.setBackgroundColor(0, 0, 0, 255) -- recommended to set bg color here

    self.player = ObjectsBasic.CircleObj:new(Geometry.Vector2:new(200, 500), nil, 20, Color:new(0, 0, 255, 255))
    self:addObject(self.player)
    self.playerRigidBody = BehaviorsPhysics.RigidBody("dynamic", "circle", 1)
    self.player:attachBehavior(self.playerRigidBody)
    self.playerRigidBody.fixture:setRestitution(0.3)
    self.playerRigidBody.fixture:setFriction(2.5)

    self.rectFloor = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(love.graphics.getWidth()/2, 600), nil, Geometry.Vector2:new(1800, 100), Color:new(127, 127, 127, 255))
    self:addObject(self.rectFloor)
    self.rectFloor:attachBehavior(BehaviorsPhysics.RigidBody("static", "rectangle", 1))

    self.rectLeft = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(0, 600), nil, Geometry.Vector2:new(10, 1200), Color:new(127, 127, 127, 255))
    self:addObject(self.rectLeft)
    self.rectLeft:attachBehavior(BehaviorsPhysics.RigidBody("static", "rectangle", 1))

    self.rectRight = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(800, 100), nil, Geometry.Vector2:new(10, 1200), Color:new(127, 127, 127, 255))
    self:addObject(self.rectRight)
    self.rectRightRigidBody = BehaviorsPhysics.RigidBody("static", "rectangle", 1)
    self.rectRight:attachBehavior(self.rectRightRigidBody)

    self.rectTop = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(0, 0), nil, Geometry.Vector2:new(4000, 10), Color:new(127, 127, 127, 255))
    self:addObject(self.rectTop)
    self.rectTop:attachBehavior(BehaviorsPhysics.RigidBody("static", "rectangle", 1))

    self.lvl = StageObject:new()
    self:addObject(self.lvl)

    self.lvlBehavior = require(self.pathToLevel):new()
    self.lvl:attachBehavior(self.lvlBehavior)

    self:addObject(ObjectsBasic.FpsObj:new())

    self.upPressed = false
    self.doneOpenDoor = false

end

function level_stage:update(dt)

    local velX, velY = self.playerRigidBody.body:getLinearVelocity()

    if love.keyboard.isDown("left") then
        self.playerRigidBody.body:applyForce(-32, 0)
    elseif love.keyboard.isDown("right") then
        self.playerRigidBody.body:applyForce(32, 0)
    end

    if love.keyboard.isDown("up") and (velY <= 0 and velY >= -1) then
        if not self.upPressed then
            self.upPressed = true
            self.playerRigidBody.body:applyLinearImpulse(0, -42)
        end
    else
        self.upPressed = false
    end

end

function level_stage:openDoor()

    if not self.doneOpenDoor then

        self.doneOpenDoor = true
        local x, y = self.rectRightRigidBody.body:getPosition()
        local targetY = y-250
            
        self:setInterval(function(timer)
            x, y = self.rectRightRigidBody.body:getPosition()
            self.rectRightRigidBody.body:setPosition(x, y-5)
            if y <= targetY then
                timer:destroy()
            end
        end, 0.0001)

    end

end


return level_stage -- don't forget to return the stage class