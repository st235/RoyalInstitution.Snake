-- 3rd party libraries
Class = require 'lib/class'
push = require 'lib/push'

require 'src/Constants'

-- definitions
require 'src/level_def'

-- utils
require 'src/GraphicUtil'

-- game logic
require 'src/SnakeSegment'
require 'src/Snake'
require 'src/Level'
require 'src/PowerUp'
require 'src/Obstacle'

gFonts = {
    ['small'] = love.graphics.newFont('resources/font/PixeloidSans.ttf', 9),
    ['medium'] = love.graphics.newFont('resources/font/PixeloidSans.ttf', 18),
    ['small-bold'] = love.graphics.newFont('resources/font/PixeloidSans-Bold.ttf', 9),
    ['medium-bold'] = love.graphics.newFont('resources/font/PixeloidSans-Bold.ttf', 18),
}
