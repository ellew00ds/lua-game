-- Initialize the player and platforms
function love.load()
    love.window.setTitle("Platform Jumping Example")
    love.window.setMode(800, 600)
    
    player = {
        x = 100,
        y = 500,
        width = 50,
        height = 50,
        speed = 200,
        jumpHeight = -400,
        gravity = 1000,
        yVelocity = 0,
        grounded = false
    }

    platforms = {
        {x = 50, y = 550, width = 700, height = 50}
        , {x = 200, y = 450, width = 100, height = 20}
        , {x = 400, y = 400, width = 100, height = 20}
        , {x = 600, y = 350, width = 100, height = 20}
        , {x = 800, y = 300, width = 100, height = 20}
        , {x = 1000, y = 250, width = 100, height = 20}
    }
end

-- Update the player position
function love.update(dt)
    -- Move left or right
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown("right") then
        player.x = player.x + player.speed * dt
    end

    -- Apply gravity
    player.yVelocity = player.yVelocity + player.gravity * dt
    player.y = player.y + player.yVelocity * dt

    -- Jumping
    if love.keyboard.isDown("space") and player.grounded then
        player.yVelocity = player.jumpHeight
        player.grounded = false
    end

    -- Check for collisions with platforms
    player.grounded = false
    for _, platform in ipairs(platforms) do
        if CheckCollision(player, platform) then
            -- Check if the player is falling
            if player.yVelocity > 0 then
                player.yVelocity = 0
                player.grounded = true
                player.y = platform.y - player.height
            end
        end
    end

    -- Prevent the player from falling through the ground
    if player.y + player.height > love.graphics.getHeight() then
        player.y = love.graphics.getHeight() - player.height
        player.yVelocity = 0
        player.grounded = true
    end

    -- Prevent the player from moving off screen
    if player.x < 0 then
        player.x = 0
    elseif player.x + player.width > love.graphics.getWidth() then
        player.x = love.graphics.getWidth() - player.width
    end
end

-- Draw the player and platforms
function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    love.graphics.setColor(0.28, 0.63, 0.05)
    for _, platform in ipairs(platforms) do
        love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
    end

    -- Debugging information
    love.graphics.setColor(1, 0, 0)
    love.graphics.print("Player Y: " .. player.y, 10, 10)
    love.graphics.print("Player Y Velocity: " .. player.yVelocity, 10, 30)
    love.graphics.print("Grounded: " .. tostring(player.grounded), 10, 50)
end

-- Function to check for collision between player and platforms
function CheckCollision(player, platform)
    return player.x < platform.x + platform.width and
           player.x + player.width > platform.x and
           player.y + player.height > platform.y and
           player.y < platform.y + platform.height
end
