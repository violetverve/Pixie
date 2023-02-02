require 'src/dependencies'

function love.load()
    cam = camera()
    world = wf.newWorld(0, 0)
    world:addCollisionClass('Tree')
    world:addCollisionClass('Player')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pixie')
    gameMap = sti('maps/testMap.lua')


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    player = Player()
    lightManager = LightManager()
    tree = Tree(300, 100)
end

function love.update(dt)
    player:update(dt)
    tree:update(dt)
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

    -- lightManager:update(dt)
    world:update(dt)

end

function love.draw()

    cam:attach()
        -- gameMap:draw()
        gameMap:drawLayer(gameMap.layers['ground'])
        gameMap:drawLayer(gameMap.layers['trees'])

        tree:render()
        player:render()

        world:draw()
        lightManager:render()
    cam:detach()
    -- love.graphics.rectangle("fill", -10, -10, 2000, 2000)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end