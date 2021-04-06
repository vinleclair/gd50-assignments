--[[
    GD50
    Match-3 Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    -- Dependencies --

    A file to organize all of the global dependencies for our project, as
    well as the assets for our game, rather than pollute our main.lua file.
]]

--
-- libraries
--
Class = require 'lib/class'

push = require 'lib/push'

-- used for timers and tweening
Timer = require 'lib/knife.timer'

--
-- our own code
--

-- utility
require 'src/StateMachine'
require 'src/Util'

-- game pieces
require 'src/Board'
require 'src/Tile'

-- game states
require 'src/states/BaseState'
require 'src/states/BeginGameState'
require 'src/states/GameOverState'
require 'src/states/PlayState'
require 'src/states/StartState'

gSounds = {
    ['music'] = love.audio.newSource('sounds/music3.mp3', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['error'] = love.audio.newSource('sounds/error.wav', 'static'),
    ['match'] = love.audio.newSource('sounds/match.wav', 'static'),
    ['clock'] = love.audio.newSource('sounds/clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('sounds/game-over.wav', 'static'),
    ['next-level'] = love.audio.newSource('sounds/next-level.wav', 'static')
}

gTextures = {
    ['main'] = love.graphics.newImage('graphics/match3.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['particle'] = love.graphics.newImage('graphics/particle.png')
}

gFrames = {
    
    -- divided into sets for each tile type in this game, instead of one large
    -- table of Quads
    ['tiles'] = GenerateTileQuads(gTextures['main'])
}

-- this time, we're keeping our fonts in a global table for readability
gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}

-- some of the colors in our palette (to be used with particle systems)
gPaletteColors = {
    -- soft orange
    [1] = {
        ['r'] = 217,
        ['g'] = 160,
        ['b'] = 102
    },
    -- soft red
    [2] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    -- dark moderate orange
    [3] = {
        ['r'] = 138,
        ['g'] = 111,
        ['b'] = 48
    },
    -- soft red
    [4] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    -- very dark desaturated yellow
    [5] = {
        ['r'] = 82,
        ['g'] = 75,
        ['b'] = 36
    },
    -- dark red
    [6] = {
        ['r'] = 172,
        ['g'] = 50,
        ['b'] = 50
    },
    -- very dark desaturated green
    [7] = {
        ['r'] = 75,
        ['g'] = 105,
        ['b'] = 47
    },
    -- very dark desaturated red
    [8] = {
        ['r'] = 102,
        ['g'] = 57,
        ['b'] = 49
    },
    -- dark moderate cyan - lime green
    [9] = {
        ['r'] = 55,
        ['g'] = 148,
        ['b'] = 110
    },
    -- dark moderate orange
    [10] = {
        ['r'] = 143,
        ['g'] = 83,
        ['b'] = 59
    },
    -- soft blue
    [11] = {
        ['r'] = 91,
        ['g'] = 110,
        ['b'] = 225
    },
    -- bright orange
    [12] = {
        ['r'] = 223,
        ['g'] = 113,
        ['b'] = 38
    },
    -- dark moderate blue
    [13] = {
        ['r'] = 48,
        ['g'] = 96,
        ['b'] = 130
    },
    -- dark grayish violet
    [14] = {
        ['r'] = 132,
        ['g'] = 126,
        ['b'] = 135
    },
    -- dark violet
    [15] = {
        ['r'] = 63,
        ['g'] = 63,
        ['b'] = 116
    },
    -- very dark grayish cyan
    [16] = {
        ['r'] = 105,
        ['g'] = 106,
        ['b'] = 106
    },
    -- dark moderate violet
    [17] = {
        ['r'] = 118,
        ['g'] = 66,
        ['b'] = 138
    },
    -- very dark grayish orange
    [18] = {
        ['r'] = 89,
        ['g'] = 86,
        ['b'] = 82
    }
}
