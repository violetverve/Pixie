ItemManager = Class{}

function ItemManager:init()
    self.items = {}
end

function ItemManager:addItem(name, x, y)
    self.items[name] = self.items[name] or {}
    self.items[name]['xy'] = self.items[name]['xy'] or {}
    self.items[name]['colliders'] = self.items[name]['colliders'] or {}
    table.insert(self.items[name]['xy'], {x, y})

    if ITEMS_DEFS[name].colliderType == 'circle' then
        collider = world:newCircleCollider(x + ITEMS_DEFS[name].width * 1.25, y + ITEMS_DEFS[name].height * 1.25, ITEMS_DEFS[name].height)
    end
    -- add other types :D

    collider:setCollisionClass('Item')
    collider:setType('static')

    collider.isTaken = false
    collider.type = name

    table.insert(self.items[name]['colliders'], collider)
end

function ItemManager:loadColliders()
    for name, objects in pairs(self.items) do
        for i, coords in ipairs(objects['xy']) do
            objects['colliders'][i] = world:newCircleCollider(coords[1] + ITEMS_DEFS[name].width * 1.25, coords[2] + ITEMS_DEFS[name].height * 1.25, ITEMS_DEFS[name].height)
            objects['colliders'][i]:setCollisionClass('Item')
            objects['colliders'][i]:setType('static')

            objects['colliders'][i].isTaken = false
            objects['colliders'][i].type = name
        end
    end
end

function ItemManager:exitColliders()
    for name, objects in pairs(self.items) do
        for _, collider in pairs(objects['colliders']) do
            collider:destroy()
        end
    end
end

function ItemManager:addItems(objects)
    for i, val in pairs(objects) do
        self:addItem(val[1], val[2], val[3])
    end
end

function ItemManager:updateColliders()
    for _, value in pairs(self.items) do
        for i, val in pairs(value['colliders']) do
            if val.isTaken then
                table.remove(value['colliders'], i)
                table.remove(value['xy'], i)
            end
        end
    end
end

function ItemManager:update()
    self:updateColliders()
end

function ItemManager:renderItemAbove()
    for key, value in pairs(self.items) do
        for _, val in pairs(value['xy']) do
            local x = val[1]
            local y = val[2]
            if y + ITEMS_DEFS[key].height - 4 <= y + player.height then
                love.graphics.draw(ITEMS_DEFS[key].image, x, y, nil, 1)
            end
        end
    end
end

function ItemManager:renderItemBelow()
    for key, value in pairs(self.items) do
        for _, val in pairs(value['xy']) do
            local x = val[1]
            local y = val[2]
            if y + ITEMS_DEFS[key].height - 4 > y + player.height then
                love.graphics.draw(ITEMS_DEFS[key].image, x, y, nil, 1)
            end
        end
    end
end