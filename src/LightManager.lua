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

    shaders:update(dt, self.opacityTrecker)
end

function LightManager:render()
    love.graphics.setShader(shaders.trueLight)
    love.graphics.rectangle("fill", -10, -10, 2000, 2000)
    love.graphics.setShader()
end