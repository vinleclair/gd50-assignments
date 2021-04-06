--[[
    GD50
    Legend of Zelda

    Author: Vincent Leclair
]]

PlayerCarryWalkState = Class{__includes = EntityWalkState}

function PlayerCarryWalkState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerCarryWalkState:enter(params)
    self.pot = params.pot
end

function PlayerCarryWalkState:update(dt)
    self.pot.x = self.entity.x
    self.pot.y = self.entity.y - self.pot.height / 2

    if love.keyboard.isDown('a') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('carry-walk-left', { pot = self.pot })
    elseif love.keyboard.isDown('d') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('carry-walk-right', { pot = self.pot })
    elseif love.keyboard.isDown('w') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('carry-walk-up', { pot = self.pot })
    elseif love.keyboard.isDown('s') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('carry-walk-down', { pot = self.pot })
    else
        self.entity:changeState('carry-idle', { pot = self.pot })
    end

    if love.keyboard.wasPressed('space') then
        Event.dispatch('throw', self.pot, self.entity.direction)
        self.entity:changeState('walk')
    end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)
end
