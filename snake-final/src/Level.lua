Level = Class{}

function Level:init(x, y, width, height, gridWidth, gridHeight, obstaclesMap)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- size of the level in square segments
    self.gridWidth = gridWidth
    self.gridHeight = gridHeight

    self.obstaclesMap = obstaclesMap

    self.isRunning = false
    self:start()
end

function Level:start()
    -- reset score every time we start the game
    self.score = 0

    self.powerups = {}
    self.obstacles = {}
    self:spawnObstacles()
    self:spawnPowerUp(3)

    local unoccupiedCells = self:getUnoccupiedCells()
    assert(#unoccupiedCells >= 5)

    local cellIndex = math.random(1, #unoccupiedCells)
    self.snake = Snake(self.x, self.y, self.gridWidth, self.gridHeight,
        unoccupiedCells[cellIndex][1], unoccupiedCells[cellIndex][2])
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

    -- if there is no snake, 
    -- this is an initialisation stage
    if self.snake then
        -- exclude snake segments
        for _, segment in pairs(self.snake.segments) do
            grid[segment.gridY][segment.gridX] = false
        end
    end

    -- exclude power ups
    for _, powerup in pairs(self.powerups) do
        grid[powerup.gridY][powerup.gridX] = false
    end

    -- exclude obstacles
    for _, obstacle in pairs(self.obstacles) do
        grid[obstacle.gridY][obstacle.gridX] = false
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

function Level:spawnObstacles()
    assert(#self.obstaclesMap == self.gridHeight)

    for i=1,self.gridHeight do
        assert(#self.obstaclesMap[i] == self.gridWidth)
        for j=1,self.gridWidth do
            if self.obstaclesMap[i][j] == 0 then
                goto continue
            end

            local obstacle = Obstacle(
                self.x + (j - 1) * SEGMENT_SIZE_PX,
                self.y + (i - 1) * SEGMENT_SIZE_PX,
                SEGMENT_SIZE_PX, SEGMENT_SIZE_PX, j, i)

            table.insert(self.obstacles, obstacle)

            ::continue::
        end
    end
end

function Level:spawnPowerUp(count)
    count = count or 1
    local unoccupiedCells = self:getUnoccupiedCells()

    for i=1,count do
        local cellIndex = math.random(1, #unoccupiedCells)
        local gridX, gridY = unoccupiedCells[cellIndex][1], unoccupiedCells[cellIndex][2]

        table.remove(unoccupiedCells, cellIndex)

        local powerup = PowerUp(
            self.x + (gridX - 1) * SEGMENT_SIZE_PX,
            self.y + (gridY - 1) * SEGMENT_SIZE_PX,
            SEGMENT_SIZE_PX, SEGMENT_SIZE_PX, gridX, gridY)

        table.insert(self.powerups, powerup)
    end
end

function Level:update(dt)
    -- closing the game window
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('space') then
        self.isRunning = true
        self:start()
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

    -- check collision with power ups
    for i, powerup in ipairs(self.powerups) do
        if self.snake:stepsOn(powerup.gridX, powerup.gridY) then
            gSounds['eat']:stop()
            gSounds['eat']:play()

            table.remove(self.powerups, i)

            self.score = self.score + 1
            self.snake:grow(1)
            self:spawnPowerUp()
        end
    end

    -- check for collisions with obstacles
    for _, obstacle in pairs(self.obstacles) do
        if self.snake:stepsOn(obstacle.gridX, obstacle.gridY) then
            gSounds['death']:stop()
            gSounds['death']:play()

            self.isRunning = false
            self.message = 'Oops'
            break
        end
    end

    -- check collision with self
    if self.snake:checkCollisionWithSelf() then
        gSounds['death']:stop()
        gSounds['death']:play()

        self.isRunning = false
        self.message = 'Oops'
    end
end

function Level:render()
    love.graphics.setColor(SNAKE_BACKGROUND_COLOR[1] / 255, SNAKE_BACKGROUND_COLOR[2] / 255, SNAKE_BACKGROUND_COLOR[3] / 255, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    for _, obstacle in pairs(self.obstacles) do
        obstacle:render()
    end

    for _, powerup in pairs(self.powerups) do
        powerup:render()
    end

    self.snake:render()

    if not self.isRunning then
        self:renderStartScreen()
    else
        self:renderScore()
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

    local title = self.message or APP_NAME

    renderWithShadow(title, gFonts['medium-bold'], textX, textY, textWidth, 'center',
        { 255, 255, 255 }, SNAKE_COLOR, textShadowOffsetX, textShadowOffsetY)

    renderWithShadow(START_GAME_TEXT, gFonts['small'],
        math.floor(self.x + (self.width - 60) / 2), math.floor(self.y + self.height / 2 + 20),
        60, 'center', { 255, 255, 255 }, SNAKE_COLOR, 1, 1)
end

function Level:renderScore()
    local font = gFonts['small']
    local textHeight = font:getHeight()
    local textWidth = 80
    love.graphics.printf('Score: ' .. tostring(self.score), font, 2, self.height - textHeight - 2, textWidth, 'left')
end
