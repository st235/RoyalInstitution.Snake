Obstacle = Class{}

function Obstacle:init(x, y, width, height, gridX, gridY)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.gridX = gridX
    self.gridY = gridY
end

function Obstacle:update(dt)
end

function Obstacle:render()
    love.graphics.setColor(SNAKE_COLOR[1] / 255, SNAKE_COLOR[2] / 255, SNAKE_COLOR[3] / 255, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 2, 2)

    -- reset color back to normal
    love.graphics.setColor(1, 1, 1, 1)
end
