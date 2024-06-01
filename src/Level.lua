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
end

function Level:update(dt)
    local newDirection = nil
    if love.keyboard.wasPressed('w') or love.keyboard.wasPressed('up') then
        newDirection = 'up'
    elseif love.keyboard.wasPressed('a') or love.keyboard.wasPressed('left') then
        newDirection = 'left'
    elseif love.keyboard.wasPressed('d') or love.keyboard.wasPressed('right') then
        newDirection = 'right'
    elseif love.keyboard.wasPressed('s') or love.keyboard.wasPressed('down') then
        newDirection = 'down'
    end

    -- do not change direction if no buttons are pressed
    if newDirection ~= nil and self.snake:canChangeDirection(newDirection) then
        self.snake.direction = newDirection
    end

    self.snake:update(dt)

    -- check collision with power up
    if self.snake:stepsOn(self.powerUp.gridX, self.powerUp.gridY) then
        self.snake:grow(1)
        self.unoccupiedCellsCount = self.unoccupiedCellsCount - 1
        self.powerUp = self:createPowerUp()
    end

    -- check collision with self
    self.snake:checkIfDied()
end

function Level:render()
    love.graphics.setColor(SNAKE_BACKGROUND_COLOR[1] / 255, SNAKE_BACKGROUND_COLOR[2] / 255, SNAKE_BACKGROUND_COLOR[3] / 255, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    if self.snake.isDead then
        love.graphics.print('Dead', gFonts['small'], 0, 0)
    end

    if self.powerUp then
        self.powerUp:render()
    end

    self.snake:render()

    self:renderStartScreen()

    -- reset color back to normal
    love.graphics.setColor(1, 1, 1, 1)
end

function Level:renderStartScreen()
    local textHeight = gFonts['medium-bold']:getHeight()

    local textWidth = 80
    local textX = math.floor(self.x + (self.width - textWidth) / 2)
    local textY = math.floor(self.y + (self.height - textHeight) / 2)
    local textShadowOffsetX = 2
    local textShadowOffsetY = 2

    love.graphics.setColor(SNAKE_COLOR[1] / 255, SNAKE_COLOR[2] / 255, SNAKE_COLOR[3] / 255, 1)
    love.graphics.printf('Snake', gFonts['medium-bold'], textX + textShadowOffsetX, textY + textShadowOffsetY, textWidth, 'center')

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Snake', gFonts['medium-bold'], textX, textY, textWidth, 'center')

    love.graphics.setColor(SNAKE_COLOR[1] / 255, SNAKE_COLOR[2] / 255, SNAKE_COLOR[3] / 255, 1)
    love.graphics.printf("Press 'space' to start", gFonts['small'],
        math.floor(self.x + (self.width - 60) / 2) + 1, math.floor(self.y + self.height / 2 + 20) + 1,
        60, 'center')

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Press 'space' to start", gFonts['small'],
        math.floor(self.x + (self.width - 60) / 2), math.floor(self.y + self.height / 2 + 20), 60, 'center')
end
