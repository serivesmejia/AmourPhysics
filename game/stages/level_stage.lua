local class = require "lib.lua-oop"
local Stage = require "amour.stage"

local level_stage = class("Stage-Level", Stage)

function level_stage:constructor(pathToLevel)

    Stage.constructor(self) -- don't forget to call superclass constructor

    print(pathToLevel)

    if not pathToLevel then
        pathToLevel = "game.levels.level_1"
    end

    assert(type(pathToLevel) == "string", "Path to level should be a string")

    self.pathToLevel = pathToLevel

    self.upPressed = false
    self.doneOpenDoor = false
    self.doneEnterAnim = false
    self.controllable = false
    self.nextLevel = "game.levels.level_1"

end

function level_stage:init()

    Core.setBackgroundColor(0, 0, 0, 255) -- recommended to set bg color here

    self.player = ObjectsBasic.CircleObj:new(Geometry.Vector2:new(-20, 500), nil, 20, Color:new(0, 0, 255, 255))
    self:addObject(self.player)
    self.playerRigidBody = BehaviorsPhysics.RigidBody("dynamic", "circle", 1)
    self.player:attachBehavior(self.playerRigidBody)
    self.playerRigidBody.fixture:setRestitution(0.21)
    self.playerRigidBody.fixture:setFriction(2.3)

    self.rectFloor = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(love.graphics.getWidth()/2, 600), nil, Geometry.Vector2:new(1800, 100), Color:new(127, 127, 127, 255))
    self:addObject(self.rectFloor)
    self.rectFloor:attachBehavior(BehaviorsPhysics.RigidBody("static", "rectangle", 1))

    self.rectLeft = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(0, 100), nil, Geometry.Vector2:new(10, 1200), Color:new(127, 127, 127, 255))
    self:addObject(self.rectLeft)
    self.rectLeftRigidBody = BehaviorsPhysics.RigidBody("static", "rectangle", 1)
    self.rectLeft:attachBehavior(self.rectLeftRigidBody)

    self.rectRight = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(800, 100), nil, Geometry.Vector2:new(10, 1200), Color:new(127, 127, 127, 255))
    self:addObject(self.rectRight)
    self.rectRightRigidBody = BehaviorsPhysics.RigidBody("static", "rectangle", 1)
    self.rectRight:attachBehavior(self.rectRightRigidBody)

    self.rectTop = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(0, 0), nil, Geometry.Vector2:new(4000, 10), Color:new(127, 127, 127, 255))
    self:addObject(self.rectTop)
    self.rectTop:attachBehavior(BehaviorsPhysics.RigidBody("static", "rectangle", 1))

    self.rectsGame = {}

    self.lvl = StageObject:new()
    self:addObject(self.lvl)

    self.lvlBehavior = require(self.pathToLevel):new()
    self.lvl:attachBehavior(self.lvlBehavior)

    self:addObject(ObjectsBasic.FpsObj:new())

    self.rPressedC = 0

    if love.keyboard.isDown("r") then
        self.rPressedC = self.rPressedC + 1
    end

    self:beginEnterAnim()

end

function level_stage:update(dt)

    -- INPUT
    self:control()

    -- CHECKING FOR DOWN RECTANGLES
    local down = 0
    for i,rect in ipairs(self.rectsGame) do
        local degrees = Math.round(rect.rotation:getDegrees())
        if degrees % 90 == 0 and not (degrees % 180 == 0) then
            rect.color:set(0, 255, 0, 255)
            down = down + 1
        else
            rect.color:set(0, 255, 127, 255)
        end
    end

    -- OPEN DOOR IF ALL RECTANGLES ARE DOWN
    if #self.rectsGame == down then
        self:openDoor()
        self:checkNextLevel()
    end

end

function level_stage:control()

    -- MOVING LEFT AND RIGHT
    if love.keyboard.isDown("left") and self.controllable then
        self.playerRigidBody.body:applyForce(-32, 0)
    elseif love.keyboard.isDown("right") and self.controllable then
        self.playerRigidBody.body:applyForce(32, 0)
    end

    -- LIMITING VELOCITY
    local velX, velY = self.playerRigidBody.body:getLinearVelocity()

    if velX > 500 then
        self.playerRigidBody.body:setLinearVelocity(500, velY)
    elseif velX < -500 then
        self.playerRigidBody.body:setLinearVelocity(-500, velY)
    end

    -- JUMPING
    if love.keyboard.isDown("up") and (velY <= 0 and velY >= -0.4) and self.controllable then
        if not self.upPressed then
            self.upPressed = true
            self.playerRigidBody.body:applyLinearImpulse(0, -40)
        end
    else
        self.upPressed = false
    end

    -- RESTARTING
    if love.keyboard.isDown("r")  then
        if self.rPressedC == 0 and self.controllable then
            self:changeStage("game.stages.level_stage", self.pathToLevel)
        end
        self.rPressedC = self.rPressedC + 1
    else
        self.rPressedC = 0
    end

end

function level_stage:openDoor()

    if not self.doneOpenDoor then

        self.doneOpenDoor = true

        self:setTimeout(function()

            local x, y = self.rectLeftRigidBody.body:getPosition()
            local targetY = y-250

            self:setInterval(function(timer)
                x, y = self.rectRightRigidBody.body:getPosition()
                self.rectRightRigidBody.body:setPosition(x, y-5)
                if y <= targetY then
                    timer:destroy()
                end
            end, 0.001)

        end, 1)

    end

end

function level_stage:checkNextLevel()

    if self.player.position.x > (love.graphics.getWidth() + 50) then
        self:changeStage("game.stages.level_stage", self.nextLevel)
    end

end

function level_stage:setNextLevel(nextLevel)
    self.nextLevel = nextLevel
end

-- SEPARATING ENTER ANIMATION INTO DIFFERENT FUNCTIONS

function level_stage:beginEnterAnim()

    if not self.doneEnterAnim then

        self.doneEnterAnim = true

        self:enterAnimA()

    end

end

function level_stage:enterAnimA()

    local pX, pY = self.playerRigidBody.body:getPosition()
    self.playerRigidBody.body:setPosition(pX-220, pY)

    self:setTimeout(function()

        local x, y = self.rectLeftRigidBody.body:getPosition()
        local targetY = y-250

        self:setInterval(function(timer)

            x, y = self.rectLeftRigidBody.body:getPosition()
            self.rectLeftRigidBody.body:setPosition(x, y-5)

            if y <= targetY then
                timer:destroy()
                self.playerRigidBody.body:applyForce(1200, 0)
                self:enterAnimB()
            end

        end, 0.001)

    end, 0)

end

function level_stage:enterAnimB()

    local isClosing = false

    self:setInterval(function(timerA)

        if self.player.position.x > 5 then

            if self.player.position.x > 40 and not self.controllable then
                self.controllable = true
                self.playerRigidBody.body:setLinearVelocity(0, 0)
            end

            if not isClosing then

                isClosing = true

                local x, y = self.rectLeftRigidBody.body:getPosition()
                local targetY = y+250

                self:setInterval(function(timerB)

                    x, y = self.rectLeftRigidBody.body:getPosition()
                    self.rectLeftRigidBody.body:setPosition(x, y+5)

                    if y >= targetY then
                        timerA:destroy()
                        timerB:destroy()
                    end

                end, 0.001)

            end

        end

    end, 0.001)

end

return level_stage -- don't forget to return the stage class