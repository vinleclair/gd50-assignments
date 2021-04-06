--[[
    GD50
    Legend of Zelda

    Author: Vincent Leclair
]]

PlayerCarryIdleState = Class{__includes = EntityIdleState}

function PlayerCarryIdleState:enter(params)
    self.pot = params.pot

    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    self.entity:changeAnimation('carry-idle-' .. self.entity.direction)
end

function PlayerCarryIdleState:update(dt)
    self.pot.x = self.entity.x
    self.pot.y = self.entity.y - self.pot.height / 2

    if love.keyboard.isDown('a') or love.keyboard.isDown('d') or
            love.keyboard.isDown('w') or love.keyboard.isDown('s') then
        self.entity:changeState('carry-walk', { pot = self.pot })
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('drop', { pot = self.pot })
    end
end
