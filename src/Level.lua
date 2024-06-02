Level = Class{}

function Level:init(x, y, width, height, gridWidth, gridHeight)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- size of the level in square segments
    self.gridWidth = gridWidth
    self.gridHeight = gridHeight

    self.isRunning = false
    self:start()
end

function Level:start()
    self.snake = Snake(self.x, self.y, self.gridWidth, self.gridHeight)
    self:spawnPowerUp()
end

function Level:getUnoccupiedCells()
    local unoccupiedCells = {}

    local grid = {}
    for i=1,self.gridHeight do
        table.insert(grid, {})
        for j=1,self.gridWidth do
            table.insert(grid[i], true)
        end
    end

    -- exclude snake segments
    for _, segment in pairs(self.snake.segments) do
        grid[segment.gridY][segment.gridX] = false
    end

    -- exclude power ups
    if self.powerUp then
        grid[self.powerUp.gridY][self.powerUp.gridX] = false
    end

    for i=1,self.gridHeight do
        for j=1,self.gridWidth do
            if grid[i][j] then
                table.insert(unoccupiedCells, { j, i })
            end
        end
    end

    return unoccupiedCells
end

function Level:spawnPowerUp(count)
    count = count or 1
    local unoccupiedCells = self:getUnoccupiedCells()

    for i=1,count do
        local cellIndex = math.random(1, #unoccupiedCells)
        local gridX, gridY = unoccupiedCells[cellIndex][1], unoccupiedCells[cellIndex][2]

        table.remove(unoccupiedCells, cellIndex)

        self.powerUp = PowerUp(self.x + (gridX - 1) * SEGMENT_SIZE_PX, self.y + (gridY - 1) * SEGMENT_SIZE_PX,
            SEGMENT_SIZE_PX, SEGMENT_SIZE_PX, gridX, gridY)
    end
end

function Level:update(dt)
    -- closing the game window
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('space') then
        self.isRunning = true
    end

    if self.isRunning then
        self:updateLevel(dt)
    end
end

function Level:updateLevel(dt)
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
        self:spawnPowerUp()
    end

    -- check collision with self
    if self.snake:checkCollisionWithSelf() then
        self.isRunning = false
    end
end

function Level:render()
    love.graphics.setColor(SNAKE_BACKGROUND_COLOR[1] / 255, SNAKE_BACKGROUND_COLOR[2] / 255, SNAKE_BACKGROUND_COLOR[3] / 255, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    if self.powerUp then
        self.powerUp:render()
    end

    self.snake:render()

    if not self.isRunning then
        self:renderStartScreen()
    end

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

    renderWithShadow(APP_NAME, gFonts['medium-bold'], textX, textY, textWidth, 'center',
        { 255, 255, 255 }, SNAKE_COLOR, textShadowOffsetX, textShadowOffsetY)

    renderWithShadow(START_GAME_TEXT, gFonts['small'],
        math.floor(self.x + (self.width - 60) / 2), math.floor(self.y + self.height / 2 + 20),
        60, 'center', { 255, 255, 255 }, SNAKE_COLOR, 1, 1)
end
