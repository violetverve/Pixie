require 'src/dependencies'
gameTimer = 0
scale = 4

world = wf.newWorld(0, 0)
world:addCollisionClass('Tree')
world:addCollisionClass('Player')
world:addCollisionClass('Item')
world:addCollisionClass('Door')

activeMap = 'valley'
gameMaps = {}
gameMaps.home = MapMaker('maps/houseInside.lua')
gameMaps.valley = MapMaker('maps/valley.lua', {
    {'apple', 100, 200},
    {'apple', 300, 300},
    {'pear', 230, 120},
    {'corn', 185, 400},
    {'orange', 132, 103},
    {'pomegranate', 174, 302},
    {'strawberry', 20, 123},
    {'tomato', 140, 211},
    {'watermelon', 320, 249},
    {'corn', 400, 400},
    {'beet', 239, 122},
    {'carrot', 340, 453},
    {'cherries', 456, 260},
    {'lemon', 276, 345},
    {'lettuce', 484, 312},
    {'pineapple', 168, 296},
    {'potato', 270, 124}
    },
    {{512, 106, 16, 16, mapTo = 'home', xy = {155, 300}}} --doors
)

function love.load()
    cam = camera()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pixie')
    world:setQueryDebugDrawing(true) 

    --push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    --    vsync = true,
    --    fullscreen = false,
    --    resizable = true
    --})

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {resizable = true, borderless = false})

    player = Player()
    lightManager = LightManager()
    playerBackpack = BackpackManager(player.backpack)
    gameMaps[activeMap]:load()

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.update(dt)
    --gameTimer = gameTimer + dt*1000
    --if  gameTimer > 1000 then
    --    mapNum = 1
    --end

    player:update(dt)
    cam:lookAt(player.x, player.y)
    world:update(dt)
    playerBackpack:update(dt)
    cameraUpdate()
    gameMaps[activeMap]:update(dt)

    if love.keyboard.wasPressed('g') then
        gameMaps[activeMap]:switchMaps('home')
    end
    if love.keyboard.wasPressed('f') then
        gameMaps[activeMap]:switchMaps('valley')
    end

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    cam:attach()
        -- gameMap:draw()
    --if mapNum == 1 then
    --    gameMap:drawLayer(gameMap.layers['ground'])
    --    gameMap:drawLayer(gameMap.layers['home'])
    --else
    --    gameMap2:drawLayer(gameMap2.layers['Tile Layer 1'])
    --    gameMap2:drawLayer(gameMap2.layers['Furniture'])
    --    gameMap2:drawLayer(gameMap2.layers['Decoration'])
    --end
        gameMaps[activeMap]:drawBeforePlayer()
        player:render()
        gameMaps[activeMap]:drawAfterPlayer()
        world:draw()
    cam:detach()

    playerBackpack:render()
end


function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

-- function switchMaps(newMapName)
--     gameMaps[activeMap]:exit()
--     activeMap = newMapName
--     gameMaps[activeMap]:load()
-- end

function cameraUpdate()
    local w = love.graphics.getWidth()/scale
    local h = love.graphics.getHeight()/scale

    local mapW = gameMaps[activeMap].gameMap.width * gameMaps[activeMap].gameMap.tilewidth
    local mapH = gameMaps[activeMap].gameMap.height * gameMaps[activeMap].gameMap.tileheight

    -- right side limit for camera
    if cam.x > (mapW - w/2) then
        cam.x = (mapW - w/2)
    end
    -- bottom limit for camera
    if cam.y > (mapH -h/2) then
        cam.y = (mapH -h/2)
    end
    -- left side limit for camera
    if cam.x < w/2 then
        cam.x = w/2
    end
    -- top limit for camera
    if cam.y < h/2 then
        cam.y = h/2
    end

    cam:zoomTo(scale)
end