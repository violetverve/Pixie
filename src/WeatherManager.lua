WeatherManager = Class{}

function WeatherManager:init()
    self.images = {'images/weather/clouds.png', 'images/weather/cloud1.png',
     'images/weather/cloud2.png', 'images/weather/cloud3.png'}
    self.clouds = {}
    self.timer = 0
end

function WeatherManager:load()
    self:cloudMaker(45, "load")
end

function WeatherManager:exit()
    self.clouds = {}
end

function WeatherManager:cloudMaker(num, state)
    while num > 0 do
        if state == "load" then
            self:makeCloud({-60, 640}, {0, 700})
        elseif state == "update" then
            self:makeCloud({-250, -140}, {0, 800})
        end
        num = num - 1
    end
end

function WeatherManager:makeCloud(x_bound, y_bound)
    cloud = {}
    cloud.image = love.graphics.newImage(self.images[math.random(1,4)])
    cloud.x = math.random(x_bound[1], x_bound[2])
    cloud.y = math.random(y_bound[1], y_bound[2])
    cloud.opacity = math.random(0.25, 0,4)
    cloud.speed = math.random(1.5, 3.0)
    table.insert(self.clouds, cloud)
end

function WeatherManager:update(dt)
    for i, cloud in pairs(self.clouds) do
        cloud.x = cloud.x + dt*cloud.speed
        cloud.y = cloud.y - dt*cloud.speed
        cloud.opacity = cloud.opacity - 0.000001*dt
        if cloud.opacity < 0.05 or cloud.x > 640 or cloud.y < 0 then 
            table.remove(self.clouds, i)
        end
    end
    self.timer = self.timer + 1
    if self.timer % 300 == 0 then
        self:cloudMaker(math.random(5, 10), "update")
        self.timer = 0
    end
end

function WeatherManager:render()
    for i, cloud in pairs(self.clouds) do
        love.graphics.setColor(0.8, 0.8, 0.8, cloud.opacity)
        love.graphics.draw(cloud.image, cloud.x, cloud.y, nil, 1)
    end
    love.graphics.setColor(1, 1, 1)
end