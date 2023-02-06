
MapMaker = Class{}

function MapMaker:init(mapPath, items)
    self.gameMap = sti(mapPath)
    self.objects = {} --managers
    self.itemManager = ItemManager()

    self.itemManager:addItems(items or {})
    self.itemManager:exitColliders()

    self.treeManager = TreeMaker(self.gameMap)
    --self.trees = {}
    --self.items = items or {}
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
