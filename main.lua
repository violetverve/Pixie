require 'src/dependencies'

function love.load()
    camera = require 'libraries/camera'
    cam = camera()

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
    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    -- left side limit for camera
    if cam.x < w/2 then
        cam.x = w/2
    end

    -- top limit for camera
    if cam.y < h/2 then
        cam.y = h/2
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    -- right side limit for camera
    if cam.x > (mapW - w/2) then
        cam.x = (mapW - w/2) 
    end

    -- bottom limit for camera
    if cam.y > (mapH -h/2) then
        cam.y = (mapH -h/2)
    end


    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    -- push:start()
    cam:attach()
        -- gameMap:draw()
        gameMap:drawLayer(gameMap.layers['ground'])
        gameMap:drawLayer(gameMap.layers['trees'])
    -- love.graphics.draw(BACKGROUND_IMAGE, 0, 0)
        player:render()
    cam:detach()
        -- push:finish()

end