
MapMaker = Class{}

function MapMaker:init(mapPath, items, doors, weather)
    -- self.name = name
    self.gameMap = sti(mapPath)
    self.objects = {} --managers
    -- self.doors = doors or {}
    self:createDoors(doors or {})

    self.itemManager = ItemManager()

    self.itemManager:addItems(items or {})
    self.itemManager:exitColliders()

    self.weather = weather or false
    self.weatherManager = WeatherManager()
    self.treeManager = TreeMaker(self.gameMap)
end

function MapMaker:load()
    self.treeManager:loadColliders()
    self.itemManager:loadColliders()
    if self.weather then
        self.weatherManager:load()
    end
end

function MapMaker:exit()
    self.treeManager:exitColliders()
    self.itemManager:exitColliders()
    -- if self.weather then
    --     self.weatherManager:exit()
    -- end
    self.weatherManager:exit()
end

function MapMaker:update(dt)
    self.treeManager:update(dt)
    self.itemManager:update()
    if self.weather then
        self.weatherManager:update(dt)
    end
end

function MapMaker:drawBeforePlayer()
    for name, layer in pairs(self.gameMap.layers) do
        if name ~= 'trees' then
            self.gameMap:drawLayer(layer)
        end
    end
    self.itemManager:renderItemAbove()
    self.treeManager:renderTreesAbove()
end

function MapMaker:drawAfterPlayer()
    self.itemManager:renderItemBelow()
    self.treeManager:renderTreesBelow()
    if self.weather then
        self.weatherManager:render()
    end
end

function MapMaker:createDoor(x, y, width, height, mapTo, xyTo)
    door = world:newRectangleCollider(x, y, width, height)
    door:setCollisionClass('Door')
    door:setType('static')
    door.mapTo = mapTo
    door.xyTo = xyTo
end

function MapMaker:createDoors(doors)
    for i, door in pairs(doors) do
        self:createDoor(door[1], door[2], door[3], door[4], door.mapTo, door.xy  )
    end
end

function MapMaker:switchMaps(newMap)
    gameMaps[activeMap]:exit()
    activeMap = newMap
    gameMaps[activeMap]:load()
end