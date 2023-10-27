function love.load()
    --variables
    gameWidth = 640
    gameHeight = 480
    love.window.setMode(gameWidth, gameHeight, {resizable=false, vsync=false})
    love.graphics.setBackgroundColor(1,1,1) --white
end

function love.keypressed(key)
end

function love.keyreleased(key)
end

function love.update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(1,1,1)
    love.graphics.setColor(1,1,1)
end
