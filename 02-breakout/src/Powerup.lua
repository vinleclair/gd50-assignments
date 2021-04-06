---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Vincent.
--- DateTime: 3/10/2021 9:27 PM
---

Powerup = Class{}

function Powerup:init(x, y, power)
    self.x = x
    self.y = y

    self.power = power

    self.dy = math.random(10,25)

    self.width = 16
    self.height = 16
end

function Powerup:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    return true
end

function Powerup:update(dt)
    self.y = self.y + self.dy * dt
end

function Powerup:render()
    love.graphics.draw(gTextures['main'], gFrames['powerups'][self.power],
            self.x, self.y)
end