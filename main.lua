require 'src/dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pixie')

    sti = require 'libraries/sti'
    gameMap = sti('maps/testMap.lua')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })


    player = Player()
end

function love.update(dt)
    player:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()
    gameMap:draw()
    -- love.graphics.draw(BACKGROUND_IMAGE, 0, 0)

    player:render()

    push:finish()
end