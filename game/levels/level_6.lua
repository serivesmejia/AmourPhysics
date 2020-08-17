local class = require "lib.lua-oop"
local Behavior = require "amour.stage.behavior"

local Lvl6 = class("Behavior-Lvl6", Behavior)

function Lvl6:constructor()

    Behavior.constructor(self)

end

function Lvl6:init()

    self.rectPlatformA = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(650, 400), Geometry.Rotation2.fromDegrees(90), Geometry.Vector2:new(50, 150), Color:new(127, 127, 127, 255))
    self:getCurrentStage():addObject(self.rectPlatformA)
    
    self.rectPlatformARigidBody = BehaviorsPhysics.RigidBody("static", "rectangle", 1)
    self.rectPlatformA:attachBehavior(self.rectPlatformARigidBody)

    self.rectPlatformB = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(400, 300), Geometry.Rotation2.fromDegrees(90), Geometry.Vector2:new(50, 150), Color:new(127, 127, 127, 255))
    self:getCurrentStage():addObject(self.rectPlatformB)
    
    self.rectPlatformBRigidBody = BehaviorsPhysics.RigidBody("static", "rectangle", 1)
    self.rectPlatformB:attachBehavior(self.rectPlatformBRigidBody)

    self.rectsGame = self:getCurrentStage().rectsGame

    self.rectA = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(648, 325), nil, Geometry.Vector2:new(50, 100), Color:new(0, 255, 127, 255))
    self:getCurrentStage():addObject(self.rectA)
    
    self.rectARigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.45)
    self.rectA:attachBehavior(self.rectARigidBody)

    self.rectB = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(400, 500), nil, Geometry.Vector2:new(50, 100), Color:new(0, 255, 127, 255))
    self:getCurrentStage():addObject(self.rectB)
    
    self.rectBRigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.82)
    self.rectB:attachBehavior(self.rectBRigidBody)

    self.rectC = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(400, 280), nil, Geometry.Vector2:new(50, 100), Color:new(0, 255, 127, 255))
    self:getCurrentStage():addObject(self.rectC)
    
    self.rectCRigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.82)
    self.rectC:attachBehavior(self.rectCRigidBody)

    table.insert(self.rectsGame, self.rectA)
    table.insert(self.rectsGame, self.rectB)
    table.insert(self.rectsGame, self.rectC)

    self:getCurrentStage():setNextLevel("game.levels.level_6")

end

return Lvl6