--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.level = params.level

    self.locked = false
    self.powerups = {}

    self.currentLevelScore = 0
    self.growPoints = 500
    self.recoverPoints = 5000

    -- give ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)

    self.balls = {}

    table.insert(self.balls, self.ball)
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)

    for k, ball in pairs(self.balls) do
        ball:update(dt)

        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))

                -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end

            gSounds['paddle-hit']:play()
        end

    end

    -- detect collision across all bricks with the ball
    for k, brick in pairs(self.bricks) do
        for l, ball in pairs(self.balls) do

        -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick) then

                -- add to score
                if (brick.locked and self.locked == false) then
                    self.score = self.score + (brick.tier * 200 + brick.color * 25) + 500
                elseif (brick.locked == false) then
                    self.score = self.score + (brick.tier * 200 + brick.color * 25)
                end

                -- trigger the brick's hit function, which removes it from play
                if (self.locked and brick.locked) then
                    gSounds['locked']:play()
                else
                    brick:hit()
                end

                -- randomly spawn a powerup
                if not brick.inPlay and math.random(1, 10) == 1 then
                    if (self.locked) then
                        power = math.random(9, 10)
                    else
                        power = 9
                    end
                    p = Powerup(
                            brick.x + brick.width / 2,
                            brick.y + brick.height / 2,
                            10
                    )

                    table.insert(self.powerups, p)
                end

                -- if we have enough points, grow the paddle one size update
                if (self.growPoints % self.score > self.paddle.size * 5) then
                    self.paddle:grow()
                end

                -- if we have enough points, recover a point of health
                if self.score > self.recoverPoints and self.health < 3 then
                    -- can't go above 3 health
                    self.health = self.health + 1

                    -- multiply recover points by 2
                    self.recoverPoints = self.recoverPoints + math.min(100000, self.recoverPoints * 2)

                    -- play recover sound effect
                    gSounds['recover']:play()
                end

                -- go to our victory screen if there are no more bricks left
                if self:checkVictory() then
                    gSounds['victory']:play()

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        ball = table.remove(self.balls, 1),
                        recoverPoints = self.recoverPoints
                    })
                end

                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if ball.x + 2 < brick.x and ball.dx > 0 then

                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8

                    -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                    -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then

                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32

                    -- top edge if no X collisions, always check
                elseif ball.y < brick.y then

                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8

                    -- bottom edge if no X collisions or top collision, last possibility
                else

                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                break
            end
        end
    end

    for k, powerup in pairs(self.powerups) do
        powerup:update(dt)

        if powerup:collides(self.paddle) then
            table.remove(self.powerups, k)

            if powerup.power == 9 then
                b = Ball(math.random(7))
                b.x = self.paddle.x + (self.paddle.width / 2) - 4
                b.y = self.paddle.y - 25
                b.dx = math.random(-200, 200)
                b.dy = math.random(-50, -60)
                table.insert(self.balls, b)
            end

            if powerup.power == 10 then
                self.locked = false
            end
        end
    end

    local ballCount = 0
    for _ in pairs(self.balls) do ballCount = ballCount + 1 end

    for k, ball in pairs(self.balls) do
    -- if ball goes below bounds, revert to serve state and decrease health
        if ball.y >= VIRTUAL_HEIGHT then
            table.remove(self.balls, k)
            ballCount = ballCount - 1
            gSounds['lost-ball']:play()

            if ballCount == 0 then
                self.health = self.health - 1
                self.paddle:shrink()
                gSounds['hurt']:play()

                if self.health == 0 then
                    gStateMachine:change('game-over', {
                        score = self.score,
                        highScores = self.highScores
                    })
                else
                    gStateMachine:change('serve', {
                        paddle = self.paddle,
                        bricks = self.bricks,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        level = self.level,
                        recoverPoints = self.recoverPoints
                    })
                end

            end

        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        if brick.locked then
            self.locked = true
        end

        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks and particles
    for k, brick in pairs(self.bricks) do
        brick:render()
        brick:renderParticles()
    end

    -- render all powerups
    for k, powerup in pairs(self.powerups) do
        powerup:render()
    end

    for k, ball in pairs(self.balls) do
        ball:render()
    end

    if (self.locked == false) then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][10], VIRTUAL_WIDTH - 125, 5)
    end

    self.paddle:render()

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay and brick.locked == false then
            return false
        end 
    end

    return true
end