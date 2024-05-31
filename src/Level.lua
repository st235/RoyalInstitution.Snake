Level = Class{}

function Level:init(x, y, width, height, gridWidth, gridHeight)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- size of the level in square segments
    self.gridWidth = gridWidth
    self.gridHeight = gridHeight

    self.snake = Snake(x, y, gridWidth, gridHeight)
    -- 1 cell is taken by snake by default
    self.unoccupiedCellsCount = LEVEL_WIDTH * LEVEL_HEIGHT - 1
    self.powerUp = self:createPowerUp()
end

function Level:createPowerUp()
    local leftUnoccupied = self.unoccupiedCellsCount

    for i=0,LEVEL_HEIGHT-1 do
        for j=0,LEVEL_WIDTH-1 do
            local unoccupied = not self.snake:stepsOn(i, j)
            local shouldSpawn = math.random(1, 100) <= (1 / leftUnoccupied * 100)

            if unoccupied then
                leftUnoccupied = leftUnoccupied - 1
            end

            if unoccupied and shouldSpawn then
                return PowerUp(self.x + j * SEGMENT_SIZE_PX, self.y + i * SEGMENT_SIZE_PX,
                    SEGMENT_SIZE_PX, SEGMENT_SIZE_PX, j, i)
            end
        end
    end

    assert(false)
end

function Level:update(dt)
    if love.keyboard.wasPressed('w') or love.keyboard.wasPressed('up') then
        self.snake.direction = 'up'
    elseif love.keyboard.wasPressed('a') or love.keyboard.wasPressed('left') then
        self.snake.direction = 'left'
    elseif love.keyboard.wasPressed('d') or love.keyboard.wasPressed('right') then
        self.snake.direction = 'right'
    elseif love.keyboard.wasPressed('s') or love.keyboard.wasPressed('down') then
        self.snake.direction = 'down'
    end

    self.snake:update(dt)
    if self.snake:stepsOn(self.powerUp.gridX, self.powerUp.gridY) then
        self.snake:grow(1)
        self.unoccupiedCellsCount = self.unoccupiedCellsCount - 1
        self.powerUp = self:createPowerUp()
    end
end

function Level:render()
    love.graphics.setColor(SNAKE_BACKGROUND_COLOR[1] / 255, SNAKE_BACKGROUND_COLOR[2] / 255, SNAKE_BACKGROUND_COLOR[3] / 255, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    if self.powerUp then
        self.powerUp:render()
    end

    self.snake:render()

    -- reset color back to normal
    love.graphics.setColor(1, 1, 1, 1)
end
