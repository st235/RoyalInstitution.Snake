require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())

    love.window.setTitle(APP_NAME)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    love.keyboard.keyPressed = {}

    local levelWidth = LEVEL['width'] * SEGMENT_SIZE_PX
    local levelHeight = LEVEL['height'] * SEGMENT_SIZE_PX
    gLevel = Level(
        math.floor((VIRTUAL_WIDTH - levelWidth) / 2),
        math.floor((VIRTUAL_HEIGHT - levelHeight) / 2),
        levelWidth, levelHeight, LEVEL['width'], LEVEL['height'], LEVEL['obstacles'])
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
    gLevel:update(dt)

    love.keyboard.keyPressed = {}
end

function love.draw()
    push:start()

    gLevel:render()

    push:finish()
end