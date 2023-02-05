
JustBigTree = Class{}

function JustBigTree:init(tree_obj)
    self.x = tree_obj.x
    self.y = tree_obj.y - 128
    self.obj = tree_obj

    self.width = 64
    self.height = 128

    self.collider = world:newRectangleCollider(self.x + 20, self.y + 108, 24, 20)
    self.collider:setCollisionClass('Tree')
    self.collider:setType('static')
end

function JustBigTree:render()
    tile = gameMap.tiles[self.obj.gid]
    love.graphics.draw(gameMap.tilesets[tile.tileset].image, tile.quad, self.x, self.y)
end


SixTrees = Class{}

function SixTrees:init(tree_obj)
    self.x = tree_obj.x
    self.y = tree_obj.y - 192
    self.obj = tree_obj

    self.width = 128
    self.height = 192

    self.collider = world:newRectangleCollider(self.x + 20, self.y + 152, 24, 20)
    self.collider:setCollisionClass('Tree')
    self.collider:setType('static')

    self.collider = world:newRectangleCollider(self.x + 84, self.y + 152, 24, 20)
    self.collider:setCollisionClass('Tree')
    self.collider:setType('static')

    self.collider = world:newRectangleCollider(self.x + 52, self.y + 168, 24, 20)
    self.collider:setCollisionClass('Tree')
    self.collider:setType('static')
end

function SixTrees:render()
    tile = gameMap.tiles[self.obj.gid]
    love.graphics.draw(gameMap.tilesets[tile.tileset].image, tile.quad, self.x, self.y)
end

