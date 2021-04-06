--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('a') or love.keyboard.isDown('d') or
       love.keyboard.isDown('w') or love.keyboard.isDown('s') then
        self.entity:changeState('walk')
    end

    local pot, index
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if self.entity:collides(object) and object.type == GAME_OBJECT_DEFS['pot'].type then
            pot = object
            index = k
            break
        end
    end

    if love.keyboard.wasPressed('space') and pot then
        self.entity:changeState('lift', { pot = pot })
    elseif love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end
end