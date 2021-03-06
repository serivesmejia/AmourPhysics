local class = require "lib.lua-oop"
local Behavior = require "amour.stage.behavior"

local Lvl3 = class("Behavior-Lvl3", Behavior)

function Lvl3:constructor()

    Behavior.constructor(self)

end

function Lvl3:init()

    self.rectsGame = self:getCurrentStage().rectsGame

    self.rectA = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(350, 500), nil, Geometry.Vector2:new(50, 100), Color:new(0, 255, 127, 255))
    self:getCurrentStage():addObject(self.rectA)
    
    self.rectARigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.7)
    self.rectA:attachBehavior(self.rectARigidBody)

    self.rectB = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(450, 500), nil, Geometry.Vector2:new(50, 100), Color:new(0, 255, 127, 255))
    self:getCurrentStage():addObject(self.rectB)
    
    self.rectBRigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.7)
    self.rectB:attachBehavior(self.rectBRigidBody)

    self.rectC = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(400, 430), Geometry.Rotation2.fromDegrees(90), Geometry.Vector2:new(50, 100), Color:new(0, 255, 127, 255))
    self:getCurrentStage():addObject(self.rectC)
    
    self.rectCRigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.5)
    self.rectC:attachBehavior(self.rectCRigidBody)

    table.insert(self.rectsGame, self.rectA)    
    table.insert(self.rectsGame, self.rectB)
    table.insert(self.rectsGame, self.rectC)

    self:getCurrentStage():setNextLevel("game.levels.level_4")

end

return Lvl3