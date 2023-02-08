
Player = Class{}

function Player:init()
    self.x = 400
    self.y = 300
    self.speed = 300
    self.spriteSheet = love.graphics.newImage('images/characters/boy-charecter.png')
    self.grid = anim8.newGrid( 12, 18, self.spriteSheet:getWidth(), self.spriteSheet:getHeight() )

    self.width = 12
    self.height = 45
 
    self.collider = world:newBSGRectangleCollider(self.x, self.y, 6*6, 4*6, 7)
    self.collider:setCollisionClass('Player')
    self.collider:setFixedRotation(true)

    self.animations = {}
    self.animations.down = anim8.newAnimation( self.grid('1-4', 1), 0.1 )
    self.animations.left = anim8.newAnimation( self.grid('1-4', 2), 0.1 )
    self.animations.right = anim8.newAnimation( self.grid('1-4', 3), 0.1 )
    self.animations.up = anim8.newAnimation( self.grid('1-4', 4), 0.1 )

    self.anim = self.animations.down

    self.dir = "right"
    self.colliders = {}
    self.backpack = {}

    self.holdingItem = {}
end

function Player:getPosition()
    return self.x, self.y
end

function Player:setPosition(x, y)
    self.x = x
    self.y = y
end

function Player:update(dt)
    self:updateMoving(dt)
    self:updateQuery()
 
end

function Player:updateQuery()
    if love.keyboard.wasPressed('space') then
        local qx, qy = self:getDirBasedCoordinates({60, -60, -30, 60}) 
        self.colliders = world:queryCircleArea(qx,  qy, 30, {"Item", 'Door'})
    else
        self.colliders = {}
    end

    for i,c in ipairs(self.colliders) do
        if c.collision_class == 'Door' then
            self:doorDetected()
        elseif c.collision_class == 'Item' then
            self:itemDetected(c)
        end    
    end
end

function Player:doorDetected()
    switchMaps('home')
end

function Player:itemDetected(collider)
    self.backpack[collider.type] = self.backpack[collider.type] or 0
    self.backpack[collider.type] = self.backpack[collider.type] + 1
    collider.isTaken = true
    collider:destroy()
end

function Player:updateHoldingItem(item)
    self.holdingItem.name = item
    self.holdingItem.x, self.holdingItem.y = self:getDirBasedCoordinates({-5, -35, -10, -5})
end

function Player:getDirBasedCoordinates(params)
    -- right, left, up, down 
    local qx, qy = self:getPosition()
    if self.dir == "right" then
        qx = qx + params[1]
    elseif self.dir == "left" then
        qx = qx + params[2]
    elseif self.dir == "up" then
        qy = qy + params[3]
    elseif self.dir == "down" then
        qy = qy + params[4]
    end
    return qx, qy
end

function Player:renderBeforePlayer()
    if self.dir == 'up' and self.holdingItem.name ~= nil  then
        love.graphics.draw(ITEMS_DEFS[self.holdingItem.name].image, self.holdingItem.x, self.holdingItem.y, nil, 2.5)
    end
end

function Player:renderAfterPlayer()
    if self.dir ~= 'up' and self.holdingItem.name ~= nil then
        love.graphics.draw(ITEMS_DEFS[self.holdingItem.name].image, self.holdingItem.x, self.holdingItem.y, nil, 2.5)
    end
end

function Player:render()
    self:renderBeforePlayer()
    self.anim:draw(player.spriteSheet, self.x, self.y, nil, 6, nil, 6, 9)
    self:renderAfterPlayer()
end

function Player:updateMoving(dt)
    local isMoving = false

    local vx = 0
    local vy = 0

    if love.keyboard.isDown("right") then
        vx = self.speed
        self.anim = self.animations.right
        isMoving = true
        self.dir = "right"
    end

    if love.keyboard.isDown("left") then
        vx = - self.speed
        self.anim = self.animations.left
        isMoving = true
        self.dir = "left"
    end

    if love.keyboard.isDown("down") then
        vy = self.speed
        self.anim = self.animations.down
        isMoving = true
        self.dir = "down"
    end

    if love.keyboard.isDown("up") then
        vy = - self.speed
        self.anim = self.animations.up
        isMoving = true
        self.dir = "up"
    end

    if not isMoving then
        self.anim:gotoFrame(2)
    end

    -- diagonal walk fixed by normalization of vector
    vec = vector(vx, vy):normalized() * player.speed
    self.collider:setLinearVelocity(vec.x, vec.y)

    self.x = self.collider:getX()
    self.y = self.collider:getY() - 30
    self.anim:update(dt)

    -- map borders provider
    if self.y <= 0 + 8*6 then
        self.collider:setLinearVelocity(vx, math.max(0, vy))
    end
    if self.y >= MAP_HEIGHT - 8*6 then
        self.collider:setLinearVelocity(vx, math.min(0, vy))
    end
    if self.x <= 0 + 5*6 then
        self.collider:setLinearVelocity(math.max(0, vx), vy)
    end
    if self.x >= MAP_WIDTH - 5*6 then
        self.collider:setLinearVelocity(math.min(0, vx), vy)
    end
    --corners
    if self.y <= 0 + 8*6 and self.x <= 0 + 5*6 then
        self.collider:setLinearVelocity(math.max(0, vx), math.max(0, vy))
    end
    if self.y >= MAP_HEIGHT - 8*6 and self.x <= 0 + 5*6 then
        self.collider:setLinearVelocity(math.max(0, vx), math.min(0, vy))
    end
    if self.y <= 0 + 8*6 and self.x >= MAP_WIDTH - 5*6 then
        self.collider:setLinearVelocity(math.min(0, vx), math.max(0, vy))
    end
    if self.y >= MAP_HEIGHT - 8*6 and self.x >= MAP_WIDTH - 5*6 then
        self.collider:setLinearVelocity(math.min(0, vx),  math.min(0, vy))
    end
end