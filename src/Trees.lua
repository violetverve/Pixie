
Tree = Class{}

function Tree:init(tree_obj, gameMap)
    self.x = tree_obj.x
    self.y = tree_obj.y - 128
    self.obj = tree_obj

    self.width = 64
    self.height = 128

    --self:loadColliders()

    self.gameMap = gameMap
end

function Tree:loadColliders()
    self.collider = world:newRectangleCollider(self.x + 20, self.y + 104, 24, 20)
    self.collider:setCollisionClass('Tree')
    self.collider:setType('static')
end

function Tree:exitColliders()
    self.collider:destroy()
end

function Tree:render()
    tile = self.gameMap.tiles[self.obj.gid]
    love.graphics.draw(self.gameMap.tilesets[tile.tileset].image, tile.quad, self.x, self.y)
end


SixTrees = Class{}

function SixTrees:init(tree_obj, gameMap)
    self.x = tree_obj.x
    self.y = tree_obj.y - 192
    self.obj = tree_obj

    self.width = 128
    self.height = 192

    --self:loadColliders()

    self.gameMap = gameMap
end

function SixTrees:loadColliders()
    self.collider1 = world:newRectangleCollider(self.x + 20, self.y + 148, 24, 20)
    self.collider1:setCollisionClass('Tree')
    self.collider1:setType('static')

    self.collider2 = world:newRectangleCollider(self.x + 84, self.y + 148, 24, 20)
    self.collider2:setCollisionClass('Tree')
    self.collider2:setType('static')

    self.collider3 = world:newRectangleCollider(self.x + 52, self.y + 168, 24, 20)
    self.collider3:setCollisionClass('Tree')
    self.collider3:setType('static')
end

function SixTrees:exitColliders()
    self.collider1:destroy()
    self.collider2:destroy()
    self.collider3:destroy()
end

function SixTrees:render()
    tile = self.gameMap.tiles[self.obj.gid]
    love.graphics.draw(self.gameMap.tilesets[tile.tileset].image, tile.quad, self.x, self.y)
end

