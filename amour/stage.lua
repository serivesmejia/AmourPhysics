local class = require "lib.lua-oop"

local Stage = class "Stage"

function Stage:constructor()

    self.v.firstUpdate = true

    self.initialized = false

    self.modules = self.stageManager.modules
    self.modules.declare()

    self.parentObj = ObjectsBasic.ParentObj:new()

    self.parentObj.parentStage = self
    self.parentObj:_init()

end

function Stage:init()

    love.graphics.setBackgroundColor(0, 0, 0)

end

function Stage:_init()

    if self.initialized then
        return
    end

    self.initialized = true

    self.parentObj:_stageInit()

    self.mouseObj = self.modules.ObjectsBasic.MouseObj:new()
    self:addObject(self.mouseObj)

    love.physics.setMeter(128)
    self.world = love.physics.newWorld(0, 9.81*love.physics.getMeter(), true)

    self:init()

end

function Stage:update(dt) end

function Stage:_update(dt)

    if self.v.firstUpdate then

        self:firstUpdate()

        print("First update of " .. self.class.name .. " (stage)")

        self.v.firstUpdate = false

    end

    self.parentObj:_update(dt)

    self.world:update(dt)

    self:update(dt)
    self.timerManager:update()

end

function Stage:firstUpdate() end

function Stage:_firstUpdate()

    self.parentObj:_stageFirstUpdate()

    self:firstUpdate()

end

function Stage:draw() end

function Stage:_draw()

    self.parentObj:_draw()

    self:draw()

end

function Stage:beforeChange(nextStage)

    print("Default beforeChange of " .. self.class.name .. " (stage)")

end

function Stage:_beforeChange(nextStage)

    self.parentObj:_beforeChange()

    self:beforeChange(nextStage)

end

function Stage:addObject(stageObject)

    stageObject.parentStage = self

    self.parentObj:addChild(stageObject)

end

function Stage:getObject(className)

    return self.parentObj:getChild(className)

end

function Stage:getObjects(className)
    return self.parentObj:getChildren(className)
end

function Stage:getAllObjects()
    return self.parentObj:getAllChildren()
end

function Stage:attachBehavior(behavior, ...)
    self.parentObj:attachBehavior(behavior, ...)
end

-- JUST SHORTCUTS

function Stage:changeStage(stage, ...)
    self.stageManager:changeStage(stage, ...)
end

function Stage:setTimeout(func, timeSecs)
    self.timerManager:setTimeout(func, timeSecs)
end

function Stage:setStaticTimeout(func, timeSecs)
    self.timerManager:setStaticTimeout(func, timeSecs)
end

function Stage:setInterval(func, timeSecs)
    self.timerManager:setInterval(func, timeSecs)
end

function Stage:setStaticInterval(func, timeSecs)
    self.timerManager:setStaticInterval(func, timeSecs)
end

function Stage:destroyTimer(timerID)
    self.timerManager:destroy(timerID)
end

return Stage
