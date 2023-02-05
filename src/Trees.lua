
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



--function Tree:update(dt)
--    if (player.y + player.height * 3 / 4) > self.y and player.y < self.y + self.height and (player.x < (self.x + self.width)) and (player.x + player.width) > self.x then
--        self.isPlayerBehind = true
--    else
--        self.isPlayerBehind = false
--    end
--end
--
--function Tree:render()
--    if self.isPlayerBehind then
--        love.graphics.setColor(1,1,1,0.4)
--    end
--    love.graphics.draw(self.image, self.x, self.y)
--    love.graphics.setColor(1,1,1)
--end
