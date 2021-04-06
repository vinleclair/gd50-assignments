--[[
    GD50
    Legend of Zelda

    Author: Vincent Leclair
]]

PlayerLiftState = Class{__includes = BaseState}

function PlayerLiftState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    self.player:changeAnimation('lift-' .. self.player.direction)
end

function PlayerLiftState:enter(params)
    self.pot = params.pot

    Timer.tween(0.3, {
        [self.pot] = {x = self.player.x, y = self.player.y - self.pot.height / 2}
    })

    self.player.currentAnimation:refresh()
end

function PlayerLiftState:update(dt)
    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('carry-idle', {
            pot = self.pot
        })
    end
end

function PlayerLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
            math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end
