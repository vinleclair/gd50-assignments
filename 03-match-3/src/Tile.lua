--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety, special)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
    self.special = special

    -- particle system belonging to the tile, emitted on hit
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    -- various behavior-determining functions for the particle system
    self.psystem:setParticleLifetime(1)
    self.psystem:setSpread(6.3)
    self.psystem:setSizes(5, 10)
    self.psystem:setEmissionRate(1)
end

function Tile:update(dt)
    self.psystem:update(dt)
end

function Tile:render(x, y)
    -- draw shadow
    love.graphics.setColor(34/255, 32/255, 52/255, 255/255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
end

--[[
    Need a separate render function for our particles so it can be called after all tiles are drawn;
    otherwise, some tiles would render over other tiles' particle systems.
]]
function Tile:renderParticles(x, y)
    self.psystem:setColors(
            gPaletteColors[self.color].r / 255,
            gPaletteColors[self.color].g / 255,
            gPaletteColors[self.color].b / 255,
            255,
            gPaletteColors[self.color].r / 255,
            gPaletteColors[self.color].g / 255,
            gPaletteColors[self.color].b / 255,
            0
    )
    if self.special then
        love.graphics.draw(self.psystem, self.x + x + 16, self.y + y + 16)
    end
end
