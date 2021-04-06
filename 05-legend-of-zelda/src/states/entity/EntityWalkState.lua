--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, dungeon)
    self.entity = entity
    self.entity:changeAnimation('walk-down')

    self.dungeon = dungeon

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0

    -- keeps track of whether we just hit a wall
    self.bumped = false
end

function EntityWalkState:update(dt)

    -- assume we didn't hit a wall
    self.bumped = false

    -- boundary checking on all sides, allowing us to avoid collision detection on tiles
    if self.entity.direction == 'left' then
        self.entity.x = self.entity.x - self.entity.walkSpeed * dt

        if self.entity.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then
            self.entity.x = MAP_RENDER_OFFSET_X + TILE_SIZE
            self.bumped = true
        end
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + self.entity.walkSpeed * dt

        if self.entity.x + self.entity.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
            self.entity.x = VIRTUAL_WIDTH - TILE_SIZE * 2 - self.entity.width
            self.bumped = true
        end
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y - self.entity.walkSpeed * dt

        if self.entity.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.entity.height / 2 then
            self.entity.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.entity.height / 2
            self.bumped = true
        end
    elseif self.entity.direction == 'down' then
        self.entity.y = self.entity.y + self.entity.walkSpeed * dt

        local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE)
            + MAP_RENDER_OFFSET_Y - TILE_SIZE

        if self.entity.y + self.entity.height >= bottomEdge then
            self.entity.y = bottomEdge - self.entity.height
            self.bumped = true
        end
    end

    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if self.entity:collides(object.hitbox) and object.solid then
            if self.entity.direction == 'left' and self.entity.x >= object.hitbox.x + object.hitbox.width - 2 then
                self.entity.x = self.entity.x - self.entity.walkSpeed * dt

                if self.entity.x <= object.hitbox.x + object.hitbox.width then
                    self.entity.x = object.hitbox.x + object.hitbox.width
                    self.bumped = true
                end
            elseif self.entity.direction == 'right' and self.entity.x + self.entity.width <= object.hitbox.x + 2 then
                self.entity.x = self.entity.x + self.entity.walkSpeed * dt

                if self.entity.x + self.entity.width >= object.hitbox.x then
                    self.entity.x = object.hitbox.x - self.entity.width
                    self.bumped = true
                end
            elseif self.entity.direction == 'up' and self.entity.y >= object.hitbox.y + object.hitbox.height - self.entity.height / 2 - 2 then
                self.entity.y = self.entity.y - self.entity.walkSpeed * dt

                if self.entity.y <= object.hitbox.y + object.hitbox.height - self.entity.height / 2 then
                    self.entity.y = object.hitbox.y + object.hitbox.height - self.entity.height / 2
                    self.bumped = true
                end
            elseif self.entity.direction == 'down' and self.entity.y + self.entity.height <= object.hitbox.y + 2 then
                self.entity.y = self.entity.y + self.entity.walkSpeed * dt

                if self.entity.y + self.entity.height >= object.hitbox.y then
                    self.entity.y = object.hitbox.y - self.entity.height
                    self.bumped = true
                end
            end
            self.bumped = true
        end
    end
end

function EntityWalkState:processAI(params, dt)
    local room = params.room
    local directions = {'left', 'right', 'up', 'down'}

    if self.moveDuration == 0 or self.bumped then
        
        -- set an initial move duration and direction
        self.moveDuration = math.random(5)
        self.entity.direction = directions[math.random(#directions)]
        self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0

        -- chance to go idle
        if math.random(3) == 1 then
            self.entity:changeState('idle')
        else
            self.moveDuration = math.random(5)
            self.entity.direction = directions[math.random(#directions)]
            self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
        end
    end

    self.movementTimer = self.movementTimer + dt
end

function EntityWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))

    --[[ debug code
    love.graphics.setColor(255, 0, 255, 255)
    love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    love.graphics.setColor(255, 255, 255, 255)
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        love.graphics.setColor(255, 0, 255, 255)
        love.graphics.rectangle('line', object.hitbox.x, object.hitbox.y, object.hitbox.width, object.hitbox.height)
        love.graphics.setColor(255, 255, 255, 255)
    end ]]
end