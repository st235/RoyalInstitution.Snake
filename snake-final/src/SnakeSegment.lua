SnakeSegment = Class{}

function SnakeSegment:init(x, y, width, height, gridX, gridY)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.gridX = gridX
    self.gridY = gridY
end

function SnakeSegment:update(dt)
end

function SnakeSegment:render()
    love.graphics.setColor(SNAKE_COLOR[1] / 255, SNAKE_COLOR[2] / 255, SNAKE_COLOR[3] / 255, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    -- reset color back to normal
    love.graphics.setColor(1, 1, 1, 1)
end
