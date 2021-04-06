--[[
    GD50
    Legend of Zelda

    Author: Vincent Leclair
]]

PlayerDropState = Class{__includes = BaseState}

function PlayerDropState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    self.player:changeAnimation('drop-' .. self.player.direction)
end

function PlayerDropState:enter(params)
    self.pot = params.pot

    local xTween, yTween
    if self.player.direction == 'left' then
        xTween = self.player.x - self.pot.width
        yTween = self.player.y + self.pot.height / 2
    elseif self.player.direction == 'right' then
        xTween = self.player.x + self.pot.width
        yTween = self.player.y + self.pot.height / 2
    elseif self.player.direction == 'up' then
        xTween = self.player.x
        yTween = self.player.y
    elseif self.player.direction == 'down' then
        xTween = self.player.x
        yTween = self.player.y + self.player.height
    end

    Timer.tween(0.3, {
        [self.pot] = {x = xTween, y = yTween}
    })

    self.player.currentAnimation:refresh()
end

function PlayerDropState:update(dt)
    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end
end

function PlayerDropState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
            math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end
