local class = require "lib.lua-oop"
local Stage = require "amour.stage"

local template_stage = class("Stage-Template", Stage)

function template_stage:constructor()

    Stage.constructor(self) -- don't forget to call superclass constructor

end

function template_stage:init()

    Core.setBackgroundColor(0, 0, 0, 255) -- recommended to set bg color here

end

function template_stage:update(dt)

    -- update code here

end

function template_stage:draw()

    -- draw code here

end

function template_stage:beforeChange()

    -- code to be executed before changing to another stages
    -- this method is called by the StageManager
    -- can be useful to destroy or stop the execution of something

end

return template_stage -- don't forget to return the stage class
