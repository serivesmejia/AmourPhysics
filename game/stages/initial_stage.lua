local class = require "lib.lua-oop"
local Stage = require "amour.stage"

local initial_stage = class("Stage-Initial", Stage)

function initial_stage:constructor()

    Stage.constructor(self) -- Don't forget to always call superclass constructor

end

function initial_stage:init()

    Core.setBackgroundColor(0, 0, 0, 255)

    love.window.setTitle("platafomer")

    local center = Geometry.Vector2:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

    self.maigamesObj = ObjectsBasic.StaticSpriteObj:new(center, nil, nil, Color:new(255, 255, 255, 255), "game/assets/img_logo_maigames.png")
    self:addObject(self.maigamesObj)

    local w, h = self.maigamesObj.image:getDimensions()
    self.maigamesObj.size:set(w, h)
    self.maigamesObj.visible = false

    self.bellSnd = love.audio.newSource("game/assets/snd_bell.ogg", "static")

    self:setTimeout(function()

        self.maigamesObj.visible = true
        self.bellSnd:play()

        self:setTimeout(function()

            self.maigamesObj.visible = false

            self:setTimeout(function()
                self:changeStage("game.stages.level_stage", "game.levels.level_1")
            end, 2)

        end, 5)

    end, 4)

end

function initial_stage:update()

    if love.keyboard.isDown("return") then
        self:changeStage("game.stages.level_stage", "game.levels.level_5")
    end

end

return initial_stage -- Don't forget to always return the stage class