local class = require "lib.lua-oop"

require "amour.util.timer"

local TimerManager = class "TimerManager"

function TimerManager:constructor()

    self.timers = {}
    self.counter = 0

end

function TimerManager:setTimeout(func, timeSecs)

    if not timeSecs or not (type(timeSecs) == "number") then
        timeSecs = 5
    end

    assert(type(func) == "function", "Parameter is not a function (TimeManager)")

    local newTimer = Timer:new(timeSecs, false, true)

    newTimer:onTimeout(func)

    newTimer:onTimeout(function(timer)
        timer:destroy()
        newTimer = nil
    end)

    self.timers[self.counter] = newTimer

    self.counter = self.counter + 1

    return self.counter - 1

end

function TimerManager:setStaticTimeout(func, timeSecs)

    local id = self:setTimeout(func, timeSecs)
    self.timers[id].static = true

    return id

end

function TimerManager:setInterval(func, timeSecs)

    if not timeSecs or not (type(timeSecs) == "number") then
        timeSecs = 0
    end

    assert(type(func) == "function", "Parameter is not a function (TimeManager)")

    local newTimer = Timer:new(timeSecs, false, true)

    newTimer:onTimeout(func)

    newTimer:onTimeout(function(timer)
        timer:requestReset()
    end)

    self.timers[self.counter] = newTimer

    self.counter = self.counter + 1

    return self.counter - 1

end

function TimerManager:setStaticInterval(func, timeSecs)

    local id = self:setInterval(func, timeSecs)
    self.timers[id].static = true

    return id

end

function TimerManager:update()

    for k,timer in pairs(self.timers) do

        if type(timer) == "table" then
            if timer.destroyed then
                self.timers[k] = nil
            else
                timer:update()
            end
        end

    end

end

function TimerManager:destroy(timerId)

    assert(type(timerId) == "number", "Parameter is not a number")

    local timer = self.timers[timerId]

    if type(timer) == "table" then
        timer:destroy()
    end

    self.timers[timerId] = nil

end

function TimerManager:cleanup()

    for k,timer in pairs(self.timers) do
        if type(timer) == "table" and not timer.static then
            self.timers[k] = nil
            timer:destroy()
        end
    end

end

return TimerManager
