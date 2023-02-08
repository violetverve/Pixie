
Player = Class{}

function Player:init()
    self.x = 1
    self.y = 1
    self.speed = 50
    self.spriteSheet = love.graphics.newImage('images/characters/boy-lua-character.png')
    self.grid = {}
    self.grid.down = anim8.newGrid( 15, 23, self.spriteSheet:getWidth(), self.spriteSheet:getHeight(), 0, 4, 1 )
    self.grid.right = anim8.newGrid( 15, 23, self.spriteSheet:getWidth(), self.spriteSheet:getHeight(), 0, 37, 1 )
    self.grid.up = anim8.newGrid( 15, 23, self.spriteSheet:getWidth(), self.spriteSheet:getHeight(), -1, 68, 1 )
    self.grid.left = anim8.newGrid( 15, 23, self.spriteSheet:getWidth(), self.spriteSheet:getHeight(), 0, 101, 1 )


    self.width = 15
    self.height = 23
 
    self.collider = world:newRectangleCollider(self.x, self.y, 8, 3)
    self.collider:setCollisionClass('Player')
    self.collider:setFixedRotation(true)

    self.animations = {}
    self.animations.down = anim8.newAnimation( self.grid.down('1-4', 1), 0.1 )
    self.animations.left = anim8.newAnimation( self.grid.left('1-4', 1), 0.1 )
    self.animations.right = anim8.newAnimation( self.grid.right('1-4', 1), 0.1 )
    self.animations.up = anim8.newAnimation( self.grid.up('1-4', 1), 0.1 )

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
    self.collider:destroy()
    self.collider = world:newRectangleCollider(x, y, 8, 3)
    self.collider:setCollisionClass('Player')
    self.collider:setFixedRotation(true)
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
            self:doorDetected(c)
        elseif c.collision_class == 'Item' then
            self:itemDetected(c)
        end
    end
end

function Player:doorDetected(collider)
    self:setPosition(collider.xyTo[1], collider.xyTo[2])
    gameMaps[activeMap]:switchMaps(collider.mapTo)
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
    self.anim:draw(player.spriteSheet, self.x, self.y)
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
        self.anim:gotoFrame(1)
    end

    -- diagonal walk fixed by normalization of vector
    vec = vector(vx, vy):normalized() * player.speed
    self.collider:setLinearVelocity(vec.x, vec.y)

    self.x = self.collider:getX() - 7
    self.y = self.collider:getY() - self.height + 4
    self.anim:update(dt)


    local mapW = gameMaps[activeMap].gameMap.width * gameMaps[activeMap].gameMap.tilewidth
    local mapH = gameMaps[activeMap].gameMap.height * gameMaps[activeMap].gameMap.tileheight

    -- map borders provider
    if self.y <= 0 then
        self.collider:setLinearVelocity(vx, math.max(0, vy))
    end
    if self.y >= mapH - self.height then
        self.collider:setLinearVelocity(vx, math.min(0, vy))
    end
    if self.x <= 0 then
        self.collider:setLinearVelocity(math.max(0, vx), vy)
    end
    if self.x >= mapW - self.width then
        self.collider:setLinearVelocity(math.min(0, vx), vy)
    end
    --corners
    if self.y <= 0 and self.x <= 0 then
        self.collider:setLinearVelocity(math.max(0, vx), math.max(0, vy))
    end
    if self.y >= mapH - self.height and self.x <= 0 then
        self.collider:setLinearVelocity(math.max(0, vx), math.min(0, vy))
    end
    if self.y <= 0 and self.x >= mapW - self.width then
        self.collider:setLinearVelocity(math.min(0, vx), math.max(0, vy))
    end
    if self.y >= mapH - self.height and self.x >= mapW - self.width then
        self.collider:setLinearVelocity(math.min(0, vx),  math.min(0, vy))
    end
end