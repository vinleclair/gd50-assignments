--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        consumable = true,
        solid = false,
        defaultState = 'full',
        states = {
            ['full'] = {
                frame = 5
            },
            ['half'] = {
                frame = 3
            },
            ['empty'] = {
                frame = 1
            }
        },
        onConsume = function(self, room, k)
            if (room.player.health < room.player.maxHealth) and self.state == 'full' then
                room.player:heal(2)
                gSounds['pickup-heart']:play()
                table.remove(room.objects, k)
            end
        end,
    },
    ['pot'] = {
        type = 'pot',
        texture = 'tiles',
        frame = 14,
        width = 16,
        height = 16,
        breakable = true,
        liftable = true,
        solid = true,
        defaultState = 'open',
        states = {
            ['open'] = {
                frame = 14
            },
            ['closed'] = {
                frame = 33
            },
            ['broken'] = {
                frame = 52
            }
        },
        onCollide = function(self, room)
            if self.state ~= 'broken' then
                self.state = 'broken'
                gSounds['break']:play()
                if math.random(5) == 1 then
                    local heart = GameObject(GAME_OBJECT_DEFS['heart'], self.x, self.y)
                    table.insert(room.objects, heart)
                    Timer.tween(0.2, {
                        [heart] = { x = heart.x + math.random(-5, 5),  y = heart.y - 5}
                    }):finish(function()
                        Timer.tween(0.2, {
                            [heart] = {y = heart.y + 5}
                        })
                    end)
                end
            end
        end
    }
}