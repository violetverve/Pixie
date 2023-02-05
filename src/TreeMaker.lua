
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
                table.insert(self.trees, Tree(obj))
            elseif obj.class == 'SixTrees' then
                table.insert(self.trees, SixTrees(obj))
            end
        end
    end
end

function TreeMaker:getTreesRelationPos(x, y)
    local trees_above = {}
    local trees_below = {}
    local transparent = nil

    for i, tree in ipairs(self.trees) do
        if tree.y + tree.height - 4 <= y + player.height then
            table.insert(trees_above, tree)
        elseif self:checkIfBehind(x, y, tree) then
            transparent = tree
        else
            table.insert(trees_below, tree)
        end
    end

    self.trees_above = trees_above
    self.trees_below = trees_below
    self.transparent = transparent
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
    if self.transparent then
        love.graphics.setColor(1,1,1,0.4)
        self.transparent:render()
        love.graphics.setColor(1,1,1)
    end
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

function TreeMaker:checkIfBehind(x, y, obj)
    if (y + player.height * 3 / 4) > obj.y + 28 and y < obj.y + obj.height - 4 and (x < (obj.x + obj.width - 4)) and (x + player.width - 9) > obj.x + 4 then
        return true
    else
        return false
    end
end