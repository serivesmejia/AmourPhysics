local class = require "lib.lua-oop"
local Behavior = require "amour.stage.behavior"

local Lvl2 = class("Behavior-Lvl2", Behavior)

function Lvl2:constructor()

    Behavior.constructor(self)

end

function Lvl2:init()

    self.rectsGame = self:getCurrentStage().rectsGame

    self.rectA = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(300, 500), nil, Geometry.Vector2:new(50, 100), Color:new(0, 255, 127, 255))
    self:getCurrentStage():addObject(self.rectA)
    
    self.rectARigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.7)
    self.rectA:attachBehavior(self.rectARigidBody)

    self.rectB = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(600, 500), nil, Geometry.Vector2:new(50, 100), Color:new(0, 255, 127, 255))
    self:getCurrentStage():addObject(self.rectB)
    
    self.rectBRigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.7)
    self.rectB:attachBehavior(self.rectBRigidBody)

    table.insert(self.rectsGame, self.rectA)    
    table.insert(self.rectsGame, self.rectB)

    self:getCurrentStage():setNextLevel("game.levels.level_3")

end

return Lvl2