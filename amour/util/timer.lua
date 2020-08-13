local class = require "lib.lua-oop"

Timer = class("Timer")

function Timer:constructor(timeOutSecs, oneShoot, start)

    self.timeOutSecs = timeOutSecs
    self.oneShoot = oneShoot

    self.destroyed = false
    self.started = false
    self.hasTimeOuted = false
    self.timeout = false

    self.onTimeouts = {}

    self.resetRequested = false

    if start then
        self:start()
    end

end

function Timer:start()

    if self.destroyed then return end

    if not (self.started) then
        self.started = true
        self.endSecs = os.clock() + self.timeOutSecs
    end

end

function Timer:update(dt)

    if (not self.started)  or self.destroyed then
        return
    end

    -- check if reset is requested (for security)
    if self.resetRequested then
        self.resetRequested = false
        self:reset(self.reqResetStart)
    end

    if os.clock() >= self.endSecs then

        if self.oneShoot then
            if self.hasTimeOuted then
                self.timeout = false;
            else
                self.timeout = true;
                self:executeOnTimeouts()
            end
        else
            self.timeout = true;
            self:executeOnTimeouts()
        end

        self.hasTimeOuted = true;

    end

end

function Timer:doTimer(dt)

    if self.destroyed then return end

    self:start()
    self:update(dt)

end

function Timer:onTimeout(func)

    if self.destroyed then return end

    assert(type(func) == "function", "Parameter is not a function (Timer)")
    table.insert(self.onTimeouts, func)

end

function Timer:reset(start)

    if self.destroyed then return end

    if start == nil then
        start = true
    end

    self.started = false
    self.hasTimeOuted = false
    self.timeout = false

    if start then
        self:start()
    end

end

function Timer:requestReset(start)

    if self.destroyed then return end

    self.resetRequested = true
    self.reqResetStart = start

end

function Timer:destroy()

    self.destroyed = true

end

function Timer:executeOnTimeouts()

    if self.destroyed then return end

    for key, func in pairs(self.onTimeouts) do
        func(self)
    end

end

return Timer
