BackpackManager = Class{}

CELL_WIDTH = 70

function BackpackManager:init(backpack)
    self.content = backpack
    self.chosen = 0
    self.keys = {}
end

function BackpackManager:update(dt)
    if love.keyboard.wasPressed('a') then
        self.chosen = self.chosen < 1 and 8 or self.chosen - 1
    end
    if love.keyboard.wasPressed('d') then
        self.chosen = self.chosen > 7 and 0 or self.chosen + 1
    end

    for name, _ in pairs(self.content) do
        if not table.contains(self.keys, name) then
            table.insert(self.keys, name)
        end
    end

    player:updateHoldingItem(self.keys[self.chosen])

 end

function BackpackManager:render()
    love.graphics.setColor(132/255, 24/255 ,28/255)
    love.graphics.rectangle('fill', (WINDOW_WIDTH / 2) - (CELL_WIDTH + 8) * 4 - 8, WINDOW_HEIGHT - CELL_WIDTH - 8, (CELL_WIDTH + 8) * 8 + 8, CELL_WIDTH + 16)
    love.graphics.setColor(1, 1, 1)

    for i = 1, 8 do
        if i == self.chosen then
            love.graphics.setColor(225/255, 162/255, 104/255)
        end
        love.graphics.rectangle('fill', (WINDOW_WIDTH / 2) - (CELL_WIDTH + 8) * (4 - i + 1), WINDOW_HEIGHT - CELL_WIDTH, CELL_WIDTH, CELL_WIDTH)
        love.graphics.setColor(1, 1, 1)
    end

    local i = 1
    local addScale = 0

    for _, name in ipairs(self.keys) do
        if i == self.chosen then
            addScale = 0.3
        else
            addScale = 0
        end
        love.graphics.draw(ITEMS_DEFS[name].image, (WINDOW_WIDTH / 2) - (CELL_WIDTH + 8) * (4 - i + 1) + 8, WINDOW_HEIGHT - CELL_WIDTH + 8, nil, 3 + addScale)

        if self.content[name] > 1 then
            love.graphics.setColor(67/255, 48/255, 31/255)
            love.graphics.printf(tostring(self.content[name]), (WINDOW_WIDTH / 2) - (CELL_WIDTH + 8) * (4 - i + 1) + CELL_WIDTH - 18, WINDOW_HEIGHT - 18, 18)
            love.graphics.setColor(1, 1, 1)
        end

        i = i + 1
    end
end