
MapMaker = Class{}

function MapMaker:init(mapPath, items, doors)
    self.gameMap = sti(mapPath)
    self.objects = {} --managers
    -- self.doors = doors or {}
    self:createDoors(doors or {})

    self.itemManager = ItemManager()

    self.itemManager:addItems(items or {})
    self.itemManager:exitColliders()

    self.treeManager = TreeMaker(self.gameMap)
end

function MapMaker:load()
    self.treeManager:loadColliders()
    self.itemManager:loadColliders()
end

function MapMaker:exit()
    self.treeManager:exitColliders()
    self.itemManager:exitColliders()
end

function MapMaker:update(dt)
    self.treeManager:update(dt)
    self.itemManager:update()
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
end

function MapMaker:createDoor(x, y, width, height)
    door = world:newRectangleCollider(x, y, width, height)
    door:setCollisionClass('Door')
    door:setType('static')
end

function MapMaker:createDoors(doors)
    for i, door in pairs(doors) do
        self:createDoor(door[1], door[2], door[3], door[4])
    end
end