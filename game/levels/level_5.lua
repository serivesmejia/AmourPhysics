local class = require "lib.lua-oop"
local Behavior = require "amour.stage.behavior"

local Lvl4 = class("Behavior-Lvl2", Behavior)

function Lvl4:constructor()

    Behavior.constructor(self)

end

function Lvl4:init()

    self.rectPlatform = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(150, 400), Geometry.Rotation2.fromDegrees(90), Geometry.Vector2:new(50, 150), Color:new(127, 127, 127, 255))
    self:getCurrentStage():addObject(self.rectPlatform)
    
    self.rectPlatformRigidBody = BehaviorsPhysics.RigidBody("static", "rectangle", 1)
    self.rectPlatform:attachBehavior(self.rectPlatformRigidBody)

    self.rectsGame = self:getCurrentStage().rectsGame

    self.rectA = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(148, 325), nil, Geometry.Vector2:new(50, 100), Color:new(0, 255, 127, 255))
    self:getCurrentStage():addObject(self.rectA)
    
    self.rectARigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.45)
    self.rectA:attachBehavior(self.rectARigidBody)

    self.rectB = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(400, 500), nil, Geometry.Vector2:new(50, 100), Color:new(0, 255, 127, 255))
    self:getCurrentStage():addObject(self.rectB)
    
    self.rectBRigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.82)
    self.rectB:attachBehavior(self.rectBRigidBody)

    table.insert(self.rectsGame, self.rectA)
    table.insert(self.rectsGame, self.rectB)

    self:getCurrentStage():setNextLevel("game.levels.level_5")

end

return Lvl4