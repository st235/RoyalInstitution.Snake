Snake = Class{}

function Snake:init(gridOffsetX, gridOffsetY, gridWidth, gridHeight, startGridX, startGridY)
    self.gridOffsetX = gridOffsetX
    self.gridOffsetY = gridOffsetY
    self.gridWidth = gridWidth
    self.gridHeight = gridHeight

    self.segments = {}
    self.direction = 'up'
    self.lastUpdated = 0

    self:createSegmentAt(startGridX, startGridY)
end

function Snake:length()
    return #self.segments
end

function Snake:canChangeDirection(newDirection)
    if self:length() == 1 then
        -- there are no problems with collision
        -- with a snake of size 1
        return true
    end

    if self.direction == 'up' and newDirection == 'down' then
        return false
    elseif self.direction == 'down' and newDirection == 'up' then
        return false
    elseif self.direction == 'left' and newDirection == 'right' then
        return false
    elseif self.direction == 'right' and newDirection == 'left' then
        return false
    else
        return true
    end
end

function Snake:checkCollisionWithSelf()
    assert(self:length() > 0)
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
    local segment = SnakeSegment(self.gridOffsetX + (gridX - 1) * SEGMENT_SIZE_PX, self.gridOffsetY + (gridY - 1) * SEGMENT_SIZE_PX,
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

    -- (-1) and (+1) to correctly wrap the grid coordinate
    -- around the grid itself
    self:createSegmentAt(
        (headSegment.gridX + dx - 1) % self.gridWidth + 1, 
        (headSegment.gridY + dy - 1) % self.gridHeight + 1)
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
