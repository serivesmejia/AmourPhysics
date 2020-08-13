local class = require "lib.lua-oop"
local Behavior = require "amour.stage.behavior"

local Lvl1 = class("Behavior-Lvl1", Behavior)

function Lvl1:constructor()

    Behavior.constructor(self)

end

function Lvl1:init()

    self.rectA = ObjectsBasic.RectangleObj:new(Geometry.Vector2:new(400, 500), nil, Geometry.Vector2:new(50, 100), Color:new(0, 255, 0, 255))
    self:getCurrentStage():addObject(self.rectA)
    
    self.rectARigidBody = BehaviorsPhysics.RigidBody("dynamic", "rectangle", 0.9)
    self.rectA:attachBehavior(self.rectARigidBody)

end

return Lvl1