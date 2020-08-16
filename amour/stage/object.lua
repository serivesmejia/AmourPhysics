local class = require "lib.lua-oop"

StageObject = class "StageObject"

function StageObject:constructor(position, rotation, size, color, offset)

    self.children = {}
    self.behaviors = {}

    self.zOrder = 0

    self.zSort = function(a,b) return a.zOrder < b.zOrder end

    self.isFirstUpdate = true
    self.enabled = true
    self.visible = true

    self.initialized = false

    self.tPos = position
    self.tRot = rotation
    self.tSize = size
    self.tCol = color

    self:setOffset(offset)

end

function StageObject:init() end

function StageObject:_init()

    if self.initialized then
        return
    end

    self.initialized = true

    self.parentStage.modules.declare()

    self.rotation = 0

    self:setPosition(self.tPos)
    self:setRotation(self.tRot)
    self:setSize(self.tSize)
    self:setColor(self.tCol)

    self.hitbox = Hitbox:new({position=self.position, size=self.size, poly=self.poly})

    self.tPos = nil
    self.tRot = nil
    self.tSize = nil
    self.tCol = nil

    self:init()

end

function StageObject:_stageInit()

    for i, obj in ipairs(self.children) do
        obj.parentStage = self
        if obj.enabled then
            obj:_stageInit()
        end
    end

    self:stageInit()

end

function StageObject:stageInit() end

function StageObject:firstUpdate() end

function StageObject:_stageFirstUpdate() 

    for i, obj in ipairs(self.children) do
        obj.parentStage = self
        if obj.enabled then
            obj:_stageFirstUpdate()
        end
    end

    self:stageFirstUpdate()

end

function StageObject:stageFirstUpdate() end

function StageObject:update(dt) end

function StageObject:_update(dt)

    if self.isFirstUpdate then

        print("First update of " .. self:getPath() .. " (object)")

        self:firstUpdate()

        self.isFirstUpdate = false

    end

    for i, obj in ipairs(self.children) do
        obj.parentObj = self
        if obj.enabled then
            obj:_update(dt)
        end
    end

    self:update(dt)

    self:updateHitbox()
    self:updateAbsPosition()
    self:updateAbsRotation()

    self:sortZChildren()

    self:updateBehaviors(dt)

end

function StageObject:_draw()

    for i, obj in ipairs(self.children) do
        obj.parentObj = self
        if obj.enabled then
            obj:_draw()
        end
    end

    if self.visible then
        self:draw()
    end

end

function StageObject:draw() end

function StageObject:_beforeChange(nextStage) 

    for i, obj in ipairs(self.children) do
        obj.parentStage = self
        if obj.enabled then
            obj:beforeChange()
        end
    end

    self:beforeChange()

end

function StageObject:beforeChange(nextStage) end

function StageObject:sortZChildren()

    table.sort(self.children, self.zSort)

end

function StageObject:attachBehavior(behavior, ...)

    if type(behavior) == "string" then
        behavior = require(behavior):new(...)
    end

    assert(type(behavior) == "table", "Behavior is not an object (StageObject)")

    behavior.parentObj = self

    table.insert(self.behaviors, behavior)
    behavior:_init()

end

function StageObject:addChild(stageObject)

    stageObject.parentObj = self
    stageObject.parentStage = self.parentStage

    stageObject:_init()

    table.insert(self.children, stageObject)

end

function StageObject:getChild(className)

    for i, obj in ipairs(self.children) do
        obj.parentObj = self
        if obj.class.name == className then
            return obj
        end
    end

    return nil

end

function StageObject:getChildren(className)

    local objects = {}

    for i, obj in ipairs(self.children) do
        obj.parentObj = self
        if obj.class.name == className then
            table.insert(objects, obj)
        end
    end

    return objects

end

function StageObject:getAllChildren()
    return self.children
end

function StageObject:updateBehaviors(dt)

    for i,behavior in ipairs(self.behaviors) do
        behavior:_update(dt)
    end

end

function StageObject:updateHitbox()

    self.hitbox.params.position = self.position
    self.hitbox.params.size = self.size
    self.hitbox.params.poly = self.poly

end

function StageObject:updateAbsPosition()

    if not self.absPosition then
        self.absPosition = Geometry.Vector2:new(0, 0)
    end

    if self.parentObj then

        local parentAbs = self.parentObj:getAbsolutePosition()
        local xAbs = parentAbs.x + self.position.x
        local yAbs = parentAbs.y + self.position.y

        self.absPosition:set(xAbs, yAbs)

    else
        self.absPosition = self.position
    end

end

function StageObject:updateAbsRotation()

    if not self.absRotation then
        self.absRotation = Geometry.Rotation2:new(0)
    end

    if self.parentObj then

        local parentAbs = self.parentObj:getAbsoluteRotation()
        
        self.absRotation:set(self.rotation)
        self.absRotation:rotate(parentAbs)

    else
        self.absRotation = self.rotation
    end

end

function StageObject:isHitting(otherObject)

    return self.hitbox:isHitting(otherObject.hitbox)

end

function StageObject:setPosition(position)

    if position then
        assert(type(position) == "table", "Position is not an object (StageObject)")
        self.position = position:clone()
    else
        self.position = Geometry.Vector2:new(0, 0)
    end

    self.absPosition = Geometry.Vector2:new(0, 0)

    self:updateAbsPosition()

end

function StageObject:setSize(size)

    if size then
        assert(type(size) == "table", "Size is not an object (StageObject)")
        self.size = size:clone()
    else
        self.size = Geometry.Vector2:new(400, 200)
    end

end

function StageObject:setRotation(rotation)

    if rotation then
        assert(type(rotation) == "table", "Rotation is not an object (StageObject)")
        self.rotation = rotation:clone()
    else
        self.rotation = Geometry.Rotation2:new(0)
    end

    self.absRotation = Geometry.Rotation2:new(0)

end


function StageObject:setOffset(offset)

    if not offset then
        self.offset = "center"
        return
    end

    if string.lower(offset) == "center" or "corner" then
        self.offset = offset
    else
        assert(false, "Offset should be either \"center\" or \"corner\"")
    end

end

function StageObject:setPolygon(poly, drawPoly)

    self.poly = poly
    self.drawPoly = drawPoly

end

function StageObject:getOffset()

    if not self.offset or string.lower(self.offset) == "center" then
        return 0.5
    elseif string.lower(self.offset) == "corner" then
        return 0
    else
        assert(false, "Offset should be either \"center\" or \"corner\"")
    end

end

function StageObject:setColor(color)

    if color then
        assert(type(color) == "table", "Color is not an object (StageObject)")
        self.color = color:clone()
    else
        self.color = Color:new(255, 255, 255, 255)
    end

end

function StageObject:getBehavior(className)

    for i, behavior in ipairs(self.behaviors) do
        behavior.parentObj = self
        if behavior.class.name == className then
            return behavior
        end
    end

    return nil

end

function StageObject:getBehaviors(className)

    local behaviors = {}

    for i, behavior in ipairs(self.behaviors) do
        behavior.parentObj = self
        if obj.class.name == className then
            table.insert(behaviors, behavior)
        end
    end

    return behavior

end

function StageObject:getAllBehaviors()
    return self.behaviors
end

function StageObject:getPath()

    if self.parentObj then
        return self.parentObj:getPath() .. "/" .. self.class.name
    else
        return self.parentStage.class.name .. "/" .. self.class.name
    end

end

function StageObject:getRelativePosition()
    return self.position
end

function StageObject:getAbsolutePosition()

    self:updateAbsPosition()
    return self.absPosition

end

function StageObject:getAbsoluteRotation()

    self:updateAbsRotation()
    return self.absRotation

end

return StageObject
