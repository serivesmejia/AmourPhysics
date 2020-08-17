modules = {

    Core             = require "amour.core",

    Stage            = require "amour.stage",
    StageManager     = require "amour.stage.manager",
    StageObject      = require "amour.stage.object",
    ObjectsBasic     = require "amour.stage.objects.basic",
    Behavior         = require "amour.stage.behavior",
    BehaviorsBasic   = require "amour.stage.behaviors.basic",
    BehaviorsPhysics = require "amour.stage.behaviors.physics",
    Hitbox           = require "amour.stage.hitbox",

    Timer            = require "amour.util.timer",
    TimerManager     = require "amour.util.timer.manager",

    Color            = require "amour.util.color",
    Math             = require "amour.util.math",
    Geometry         = require "amour.util.math.geometry",
    GeometryRect     = require "amour.util.math.geometry.rectangle",

    Camera           = require "lib.camera",
    class            = require "lib.lua-oop",

    declare = function()

        class = modules.class

        Core = modules.Core

        Stage = modules.Stage
        StageManager = modules.StageManager
        StageObject = modules.StageObject
        ObjectsBasic = modules.ObjectsBasic
        Behavior = modules.Behavior
        BehaviorsBasic = modules.BehaviorsBasic
        BehaviorsPhysics = modules.BehaviorsPhysics
        Hitbox = modules.Hitbox

        Color = modules.Color
        Math = modules.Math
        Geometry = modules.Geometry
        GeometryRect = modules.GeometryRect

        Timer = modules.Timer
        TimerManager = modules.TimerManager

    end

}

return modules
