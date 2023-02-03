Item = Class{}

function Item:init()
    self.x = 300
    self.y = 300

    self.width = 16
    self.height = 16

    self.isTaken = false

    self.image = love.graphics.newImage('images/items/apple_red.png')

    self.collider = world:newCircleCollider(self.x + 8 * 2.5, self.y+8 * 2.5, 16)
    self.collider:setCollisionClass('Item')
    self.collider:setType('static')
end

function Item:update()

end

function Item:render()
    -- self.image.draw()
    -- if not self.isTaken then
        love.graphics.draw(self.image, self.x, self.y, nil, 2.5)
    -- end
    -- self.anim:draw(player.spriteSheet, self.x, self.y, nil, 6, nil, 6, 9)
end