--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- some object properties
    self.breakable = def.breakable or false
    self.consumable = def.consumable or false
    self.liftable = def.liftable or false
    self.solid = def.solid or false

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    self.hitbox = Hitbox(math.floor(self.x + self.width / 4), math.floor(self.y + self.height / 4), math.floor(self.width / 2), math.floor(self.height / 2 ))

    -- default empty collision callback
    self.onCollide = def.onCollide or function()  end
    self.onConsume = def.onConsume or function()  end
end

function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
            self.y + self.height < target.y or self.y > target.y + target.height)
end

function GameObject:update(dt)
    self.hitbox.x = math.floor(self.x + self.width / 4)
    self.hitbox.y = math.floor(self.y + self.height / 4)
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end