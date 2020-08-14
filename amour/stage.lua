local class = require "lib.lua-oop"

local Stage = class "Stage"

function Stage:constructor()

    self.v.firstUpdate = true
    self.objects = {}

    self.initialized = false

    self.modules = self.stageManager.modules
    self.modules.declare()

end

function Stage:init()

    love.graphics.setBackgroundColor(0, 0, 0)

end

function Stage:_init()

    if self.initialized then
        return
    end

    self.initialized = true

    for i, obj in ipairs(self.objects) do
        obj.parentStage = self
        if obj.enabled then
            obj:stageInit()
        end
    end

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

    for i, obj in ipairs(self.objects) do
        obj.parentStage = self
        if obj.enabled then
            obj:_update(dt)
        end
    end

    self.world:update(dt)

    self:update(dt)
    self.timerManager:update()

end

function Stage:firstUpdate() end

function Stage:_firstUpdate()

    for i, obj in ipairs(self.objects) do
        obj.parentStage = self
        if obj.enabled then
            obj:firstStageUpdate()
        end
    end

    self:firstUpdate()

end

function Stage:draw() end

function Stage:_draw()

    for i, obj in ipairs(self.objects) do
        obj.parentStage = self
        if obj.enabled then
            obj:_draw()
        end
    end

    self:draw()

end

function Stage:beforeChange(nextStage)

    print("Default beforeChange of " .. self.class.name .. " (stage)")

end

function Stage:_beforeChange(nextStage)

    for i, obj in ipairs(self.objects) do
        obj.parentStage = self
        if obj.enabled then
            obj:beforeChange()
        end
    end

    self:beforeChange(nextStage)

end

function Stage:addObject(stageObject)

    stageObject.parentStage = self

    stageObject:_init()

    table.insert(self.objects, stageObject)

end

function Stage:getObject(className)

    for i, obj in ipairs(self.objects) do
        obj.parentStage = self
        if obj.class.name == className then
            return obj
        end
    end

    return nil

end

function Stage:getObjects(className)

    local objects = {}

    for i, obj in ipairs(self.objects) do
        obj.parentStage = self
        if obj.class.name == className then
            table.insert(objects, obj)
        end
    end

    return objects

end

function Stage:getAllObjects()
    return self.objects
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
