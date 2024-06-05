--[[
    Renders text on the screen with a shadow behind it.
]]
function renderWithShadow(text, font, x, y, limit, align,
    textColor, shadowColor, shadowOffsetX, shadowOffsetY)
    textColor = textColor or { 255, 255, 255 }
    shadowColor = shadowColor or { 255, 255, 255 }
    shadowOffsetX = shadowOffsetX or 1
    shadowOffsetY = shadowOffsetY or 1

    love.graphics.setColor(shadowColor[1] / 255, shadowColor[2] / 255, shadowColor[3] / 255, 1)
    love.graphics.printf(text, font, x + shadowOffsetX, y + shadowOffsetY, limit, align)

    love.graphics.setColor(textColor[1] / 255, textColor[2] / 255, textColor[3] / 255, 1)
    love.graphics.printf(text, font, x, y, limit, align)
end
