-- 3rd party libraries
Class = require 'lib/class'
push = require 'lib/push'

require 'src/Constants'

-- game logic
require 'src/SnakeSegment'
require 'src/Snake'
require 'src/Level'
require 'src/PowerUp'

gFonts = {
    ['small'] = love.graphics.newFont('resources/font/PixeloidSans.ttf', 9),
    ['medium'] = love.graphics.newFont('resources/font/PixeloidSans.ttf', 18),
    ['small-bold'] = love.graphics.newFont('resources/font/PixeloidSans-Bold.ttf', 9),
    ['medium-bold'] = love.graphics.newFont('resources/font/PixeloidSans-Bold.ttf', 18),
}
