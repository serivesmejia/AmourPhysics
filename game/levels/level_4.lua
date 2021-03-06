local class = require "lib.lua-oop"
local Behavior = require "amour.stage.behavior"

local Lvl4 = class("Behavior-Lvl4", Behavior)

function Lvl4:constructor()

    Behavior.constructor(self)

end

function Lvl4:init()

    self.rectsGame = self:getCurrentStage().rectsGame

    self.rectA = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(385, 500), Geometry.Rotation2.fromDegrees(40), Geometry.Vector2:new(50, 100), Color:new(0, 255, 127, 255))
    self:getCurrentStage():addObject(self.rectA)
    
    self.rectARigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.4)
    self.rectA:attachBehavior(self.rectARigidBody)

    self.rectB = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(515, 500), Geometry.Rotation2.fromDegrees(-40), Geometry.Vector2:new(50, 100), Color:new(0, 255, 127, 255))
    self:getCurrentStage():addObject(self.rectB)
    
    self.rectBRigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.4)
    self.rectB:attachBehavior(self.rectBRigidBody)

    self.rectC = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(450, 500), nil, Geometry.Vector2:new(50, 100), Color:new(0, 255, 127, 255))
    self:getCurrentStage():addObject(self.rectC)
    
    self.rectCRigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.5)
    self.rectC:attachBehavior(self.rectCRigidBody)

    self.rectD = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(450, 450), Geometry.Rotation2.fromDegrees(90), Geometry.Vector2:new(50, 100), Color:new(0, 255, 127, 255))
    self:getCurrentStage():addObject(self.rectD)
    
    self.rectDRigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.3)
    self.rectD:attachBehavior(self.rectDRigidBody)

    table.insert(self.rectsGame, self.rectA)    
    table.insert(self.rectsGame, self.rectB)
    table.insert(self.rectsGame, self.rectC)
    table.insert(self.rectsGame, self.rectD)

    self:getCurrentStage():setNextLevel("game.levels.level_5")

end

return Lvl4