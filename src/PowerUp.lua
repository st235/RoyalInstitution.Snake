PowerUp = Class{}

function PowerUp:init(x, y, width, height, gridX, gridY)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.gridX = gridX
    self.gridY = gridY
end

function PowerUp:update(dt)
end

function PowerUp:render()
    love.graphics.setColor(SNAKE_COLOR[1] / 255, SNAKE_COLOR[2] / 255, SNAKE_COLOR[3] / 255, 1)
    love.graphics.circle('fill', math.floor(self.x + self.width / 2), math.floor(self.y + self.height / 2),
        math.floor(math.min(self.width, self.height) / 2))

    -- reset color back to normal
    love.graphics.setColor(1, 1, 1, 1)
end
