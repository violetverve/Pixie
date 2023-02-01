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
    lightManager = LightManager()
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
    
    -- img = love.graphics.newImage('images/characters/boy-charecter.png')
    
    lightManager:update(dt)
end

function love.draw()
    -- push:start()
    cam:attach()
        -- gameMap:draw()
        gameMap:drawLayer(gameMap.layers['ground'])
        gameMap:drawLayer(gameMap.layers['trees'])
        player:render()
        lightManager:render()

        -- draw an image with lower opacity
        -- love.graphics.setColor(1, 1, 1, timer * 0.1)
        -- love.graphics.draw(img, 0,0, nil, 6)
        -- love.graphics.setColor(1, 1, 1) 
    cam:detach()
        -- push:finish()

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end