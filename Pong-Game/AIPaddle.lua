-- create a new AI paddle class that is similar to the Paddle class, but with some additional 
-- logic for controlling the paddle's movement:

AIPaddle = Class{}

function AIPaddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
    self.collisionTimer = 0
end

function AIPaddle:collides(ball)
    -- Check if the left edge of the ball is farther to the right than the right edge of the paddle
    if ball.x > self.x + self.width then
        return false
    end

    -- Check if the right edge of the ball is farther to the left than the left edge of the paddle
    if self.x > ball.x + ball.width then
        return false
    end

    -- Check if the top edge of the ball is lower than the bottom edge of the paddle
    if ball.y > self.y + self.height then
        return false
    end

    -- Check if the bottom edge of the ball is higher than the top edge of the paddle
    if self.y > ball.y + ball.height then
        return false
    end

    -- If a collision has occurred, reset the collision timer
    self.collisionTimer = 0

    -- If none of the above conditions are true, the ball and paddle are overlapping
    return true
end


function AIPaddle:update(dt, ball)
    COLLISION_THRESHOLD = 0.5
    -- Only move the paddle if the ball is on the AI's side of the screen
    if ball.x > VIRTUAL_WIDTH / 2 then
        -- Check if the AI paddle and ball have collided
        if self:collides(ball) then
            -- Start the timer
            self.collisionTimer = 0
        end

        -- Check if the timer is greater than a certain threshold
        if self.collisionTimer == nil or self.collisionTimer > COLLISION_THRESHOLD then
            -- Predict the ball's future position based on its current velocity
            local predictedX = ball.x + ball.dx * dt
            local predictedY = ball.y + ball.dy * dt

            -- Calculate the distance between the AI paddle's y-position and the predicted y-position of the ball
            local diff = predictedY - (self.y + self.height / 2)

            -- Adjust the paddle's velocity based on the distance to the predicted ball position
            if diff < 0 then
                self.dy = -PADDLE_SPEED
            elseif diff > 0 then
                self.dy = PADDLE_SPEED
            else
                self.dy = 0
            end
        else
            -- If the timer is not greater than the threshold, stop the paddle from moving
            self.dy = 0
        end

        -- Clamp the paddle's y-position within the bounds of the screen
        self.y = math.max(0, math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt))

        -- Update the timer
        self.collisionTimer = self.collisionTimer + dt
    end
end

function AIPaddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end