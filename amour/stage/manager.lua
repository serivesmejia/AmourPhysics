local class = require "lib.lua-oop"
local Camera = require "lib.Camera"

StageManager = class "StageManager"

function StageManager:constructor(initialStage, modules)

    self.timerManager = modules.TimerManager:new()
    self.modules = modules
    
    self.camera = Camera()

    self:changeStage(initialStage)

end

function StageManager:update(dt)

    self.camera:update(dt)

    self:getCurrentStage():_update(dt)

end

function StageManager:draw()

    self.camera:attach()
      self:getCurrentStage():_draw()
    self.camera:detach()

    self.camera:draw()

end

function StageManager:changeStage(stage, ...)

    if type(stage) == "string" then
        stageObj = require(stage)
        stageObj.stageManager = self
        stageObj.camera = self.camera
        stage = stageObj:new(...)
    end

    assert(type(stage) == "string" or type(stage) == "table", "Stage is not a string path or an object (StageManager)")

    self.timerManager:cleanup()

    if self.currentStage then
        self.currentStage:_beforeChange(nextStage)
    end

    self.currentStage = stage

    print("Change stage to " .. self.currentStage.class.name)

    -- Defining some util instances in the stage
    self.currentStage.stageManager = self
    self.currentStage.timerManager = self.timerManager
    self.currentStage.modules = self.modules

    self.currentStage:_init()

end

function StageManager:getCurrentStage()

    return self.currentStage

end

return StageManager
