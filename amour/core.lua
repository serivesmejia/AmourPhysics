require "amour.util.color"

local Core = {}

function Core.getBackgroundColor()

    return Color.fromBackgroundColor()

end

function Core.setBackgroundColor(r, g, b, a)

    if type(r) == "table" then
        r, g, b, a = r.get()
    end

    love.graphics.setBackgroundColor(r/255, g/255, b/255, a/255)

end

function Core.getImageScaleForNewDimensions( image, newWidth, newHeight )

    local currentWidth, currentHeight = image:getDimensions()
    return ( newWidth / currentWidth ), ( newHeight / currentHeight )

end

return Core
