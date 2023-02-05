-- Item = Class{}

-- function Item:init()
--     self.x = 300
--     self.y = 300

--     self.width = 16
--     self.height = 16

--     self.renderAbove = true

--     self.image = love.graphics.newImage('images/items/apple_red.png')

--     self.collider = world:newCircleCollider(self.x + 8 * 2.5, self.y+8 * 2.5, 16)
--     self.collider:setCollisionClass('Item')
--     self.collider:setType('static')

--     self.collider.isTaken = false
--     self.collider.type = 'apple'
-- end

-- function Item:update()
--     if self.y + self.height - 4 <= player.y + player.height then
--         self.renderAbove = true
--     else 
--         self.renderAbove = false
--     end
-- end

-- function Item:renderItemAbove()
--     if self.renderAbove and not self.collider.isTaken then
--         love.graphics.draw(self.image, self.x, self.y, nil, 2.5)
--     end
-- end

-- function Item:renderItemBelow()
--     if not self.renderAbove and not self.collider.isTaken then
--         love.graphics.draw(self.image, self.x, self.y, nil, 2.5)
--     end
-- end
