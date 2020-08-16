local modules = require "modules"

local stageManager = nil

profilerEnabled = false -- toggle on or off the profiler (wont work changing it on runtime)

function love.load()

    love.window.setTitle("")

    love.graphics.setDefaultFilter('nearest', 'nearest') -- recommended

    -- profiling stuff, attaches to love module
    love.profiler = require('lib/profile')
    love.profiler.start()
    love.frame = 0

    -- setting the seed with the current time for better random results
    math.randomseed(os.clock()*100000000000)

    stageManager = modules.StageManager:new("game.stages.initial_stage", modules)

end

function love.update(dt)

    math.randomseed(os.clock()*100000000000)

    stageManager:update(dt)

    -- profiling
    love.frame = love.frame + 1
    if love.frame%100 == 0 and profilerEnabled then
        love.report = love.profiler.report(30)
        print(love.report or "Please wait...")
        love.profiler.reset()
    elseif not profilerEnabled then
        love.profiler.stop()
    end

end

function love.draw()

    stageManager:getCurrentStage():_draw()

end
