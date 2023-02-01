LightManager = Class{}

function LightManager:init()
    self.x = 0
    self. y = 0

    -- map parameters
    self.height = 1920
    self.width = 1920

    self.timer = 0
    self.opacityTrecker = 0
end


function LightManager:update(dt)
    self.timer = self.timer + dt * 10

    if self.timer < DAY_DUR then
        self.opacityTrecker = 0
    elseif self.timer < (DAY_DUR + TRANSITION_DUR) then
        self.opacityTrecker = self.opacityTrecker + 0.01
    elseif self.timer < (DAY_NIGHT_DUR + TRANSITION_DUR) then
        self.opacityTrecker = self.opacityTrecker
    elseif self.timer < (DAY_NIGHT_DUR + 2 * TRANSITION_DUR) then 
        self.opacityTrecker = self.opacityTrecker - 0.01
    else
        self.timer = 0
    end
end

function LightManager:render()
    love.graphics.setColor(0, 0, 0, self.opacityTrecker * 0.1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1) 
end