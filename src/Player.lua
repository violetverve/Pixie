
Player = Class{}

function Player:init()
    self.x = 400
    self.y = 200
    self.speed = 5
    self.spriteSheet = love.graphics.newImage('images/characters/boy-charecter.png')
    self.grid = anim8.newGrid( 12, 18, self.spriteSheet:getWidth(), self.spriteSheet:getHeight() )

    self.animations = {}
    self.animations.down = anim8.newAnimation( self.grid('1-4', 1), 0.1 )
    self.animations.left = anim8.newAnimation( self.grid('1-4', 2), 0.1 )
    self.animations.right = anim8.newAnimation( self.grid('1-4', 3), 0.1 )
    self.animations.up = anim8.newAnimation( self.grid('1-4', 4), 0.1 )

    self.anim = self.animations.down
end

function Player:update(dt)
    local isMoving = false

    if love.keyboard.isDown("right") then
        self.x = self.x + self.speed
        self.anim = self.animations.right
        isMoving = true
    end

    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed
        self.anim = self.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("down") then
        self.y = self.y + self.speed
        self.anim = self.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("up") then
        self.y = self.y - self.speed
        self.anim = self.animations.up
        isMoving = true
    end

    if not isMoving then
        self.anim:gotoFrame(2)
    end

    self.anim:update(dt)
end

function Player:render()
    self.anim:draw(player.spriteSheet, self.x, self.y, nil, 6, nil, 6, 9)
end