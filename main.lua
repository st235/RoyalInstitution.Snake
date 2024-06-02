math.randomseed(os.time())

require 'src/Dependencies'

local levelWidth = LEVEL_WIDTH * SEGMENT_SIZE_PX
local levelHeight = LEVEL_HEIGHT * SEGMENT_SIZE_PX
level = Level(math.floor((VIRTUAL_WIDTH - levelWidth) / 2), math.floor((VIRTUAL_HEIGHT - levelHeight) / 2),
    levelWidth, levelHeight, LEVEL_WIDTH, LEVEL_HEIGHT)

function love.load()
    love.window.setTitle(APP_NAME)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    love.keyboard.keyPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keyPressed[key] or false
end

function love.update(dt)
    level:update(dt)

    love.keyboard.keyPressed = {}
end

function love.draw()
    push:start()

    love.graphics.clear(SNAKE_COLOR[1] / 255, SNAKE_COLOR[2] / 255, SNAKE_COLOR[3] / 255, 1)

    level:render()

    push:finish()
end