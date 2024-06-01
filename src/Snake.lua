Snake = Class{}

function Snake:init(gridOffsetX, gridOffsetY, gridWidth, gridHeight)
    self.gridOffsetX = gridOffsetX
    self.gridOffsetY = gridOffsetY
    self.gridWidth = gridWidth
    self.gridHeight = gridHeight

    self.segments = {}
    self.direction = 'up'
    self.lastUpdated = 0
    self.isDead = false

    local veryFirstSegmentGridX = math.random(0, gridWidth - 1)
    local veryFirstSegmentGridY = math.random(0, gridHeight - 1)
    self:createSegmentAt(veryFirstSegmentGridX, veryFirstSegmentGridY)
end

function Snake:checkIfDied()
    self.isDead = self.isDead or self:hasDied()
end

function Snake:hasDied()
    assert(#self.segments > 0)
    if #self.segments <= 3 then
        return false
    end

    local headSegment = self.segments[1]

    for i=2,#self.segments do
        local segment = self.segments[i]
        if segment.gridX == headSegment.gridX and segment.gridY == headSegment.gridY then
            return true
        end
    end

    return false
end

function Snake:stepsOn(gridX, gridY)
    for _, segment in pairs(self.segments) do
        if segment.gridX == gridX and segment.gridY == gridY then
            return true
        end
    end

    return false
end

function Snake:createSegmentAt(gridX, gridY)
    local segment = SnakeSegment(self.gridOffsetX + gridX * SEGMENT_SIZE_PX, self.gridOffsetY + gridY * SEGMENT_SIZE_PX,
        SEGMENT_SIZE_PX, SEGMENT_SIZE_PX, gridX, gridY)
    table.insert(self.segments, 1, segment)
end

function Snake:grow(count)
    assert(#self.segments > 0)

    local lastSegment = self.segments[#self.segments]

    for i=1,count do
        local segment = SnakeSegment(lastSegment.x, lastSegment.y, lastSegment.width, lastSegment.height,
            lastSegment.gridX, lastSegment.gridY)
        table.insert(self.segments, segment)
    end
end

function Snake:move(dx, dy)
    assert(#self.segments > 0)

    local headSegment = self.segments[1]

    -- remove the last segment
    table.remove(self.segments, #self.segments)

    self:createSegmentAt((headSegment.gridX + dx) % self.gridWidth, (headSegment.gridY + dy) % self.gridHeight)
end

function Snake:willMove(dt)
    return (self.lastUpdated + dt) >= SNAKE_UPDATE_INTERVAL
end

function Snake:update(dt)
    self.lastUpdated = self.lastUpdated + dt
    if self.lastUpdated < SNAKE_UPDATE_INTERVAL then
        return
    end

    -- self.lastUpdated >= SNAKE_UPDATE_INTERVAL
    self.lastUpdated = self.lastUpdated % SNAKE_UPDATE_INTERVAL

    if self.direction == 'up' then
        self:move(0, -1)
    elseif self.direction == 'left' then
        self:move(-1, 0)
    elseif self.direction == 'right' then
        self:move(1, 0)
    else -- direction is down
        self:move(0, 1)
    end
end

function Snake:render()
    for i=1,#self.segments do
        self.segments[i]:render()
    end
end
