
TreeMaker = Class{}

function TreeMaker:init()
    self.trees = {}
    self.trees_above = {}
    self.trees_below = {}
end

function TreeMaker:findTrees()
    if gameMap.layers['trees'] then
        for i, obj in pairs(gameMap.layers['trees'].objects) do
            if obj.class == 'BigTree' or obj.class == 'JustTree' then
                table.insert(self.trees, JustBigTree(obj))
            elseif obj.class == 'SixTrees' then
                table.insert(self.trees, SixTrees(obj))
            end
        end
    end
end

function TreeMaker:getTreesRelationPos(x, y)
    local trees_above = {}
    local trees_below = {}

    for i, tree in ipairs(self.trees) do
        if tree.y + tree.height - 4 <= y + player.height then
            table.insert(trees_above, tree)
        else
            table.insert(trees_below, tree)
        end
    end

    self.trees_above = trees_above
    self.trees_below = trees_below
end


function TreeMaker:update(dt)
    self:getTreesRelationPos(player.x, player.y)
end

function TreeMaker:renderTreesAbove()
    for i, tree in pairs(self.trees_above) do
        tree:render()
    end
end

function TreeMaker:renderTreesBelow()
    for i, tree in pairs(self.trees_below) do
        tree:render()

   end
end

function TreeMaker:render()
    for i, tree in pairs(self.trees) do
        tree:render()
    end
    --tile = gameMap.tiles[1]
    --love.graphics.draw(gameMap.tilesets[tile.tileset].image, tile.quad, 0, 0)
end