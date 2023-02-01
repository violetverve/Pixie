
Tree = Class{}

function Tree:init(x, y)
    self.x = x
    self.y = y
    self.image = love.graphics.newImage('images/big_tree.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.collider = world:newRectangleCollider(self.x + 16, self.y + 104, 23, 16)
    self.collider:setCollisionClass('Tree')
    self.collider:setType('static')

    self.isPlayerBehind = false
end

function Tree:update(dt)
    if (player.y + player.height * 3 / 4) > self.y and player.y < self.y + self.height and (player.x < (self.x + self.width)) and (player.x + player.width) > self.x then
        self.isPlayerBehind = true
    else
        self.isPlayerBehind = false
    end
end

function Tree:render()
    if self.isPlayerBehind then
        love.graphics.setColor(1,1,1,0.4)
    end
    love.graphics.draw(self.image, self.x, self.y)
    love.graphics.setColor(1,1,1)
end