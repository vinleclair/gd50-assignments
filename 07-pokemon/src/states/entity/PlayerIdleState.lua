--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('a') then
        self.entity.direction = 'left'
        self.entity:changeState('walk')
    elseif love.keyboard.isDown('d') then
        self.entity.direction = 'right'
        self.entity:changeState('walk')
    elseif love.keyboard.isDown('w') then
        self.entity.direction = 'up'
        self.entity:changeState('walk')
    elseif love.keyboard.isDown('s') then
        self.entity.direction = 'down'
        self.entity:changeState('walk')
    end
end