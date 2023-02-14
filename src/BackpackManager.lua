BackpackManager = Class{}

CELL_WIDTH = 48
CELL_HEIGHT = 48
BACKPACK_IMG = love.graphics.newImage('images/backpack2.png')
BACKPACK_PANEL_IMG = love.graphics.newImage('images/backpack-panel.png')
BACKPACK_CHOSEN_IMG = love.graphics.newImage('images/backpack-chosen.png')
BACKPACK_IN_ROW = 10

function BackpackManager:init(backpack)
    self.content = backpack
    self.chosen = 1
    --self.keysPanel = {}

    self.openBackpack = false
    self.keysBackpack = {}
end

function BackpackManager:update(dt)
    if love.keyboard.wasPressed('a') then
        self.chosen = self.chosen < 2 and 10 or self.chosen - 1
    end
    if love.keyboard.wasPressed('d') then
        self.chosen = self.chosen > 9 and 1 or self.chosen + 1
    end
    if love.keyboard.wasPressed('b') then
        self.openBackpack = not self.openBackpack
    end

    for name, _ in pairs(self.content) do
        --if #self.keysPanel < 10 then
        --    if not table.contains(self.keysPanel, name) then
        --        table.insert(self.keysPanel, name)
        --    end
        --if not table.contains(self.keysPanel, name) then
        if not table.contains(self.keysBackpack, name) then
            table.insert(self.keysBackpack, name)
        end
        --end
    end
    player:updateHoldingItem(self.keysBackpack[self.chosen])
    self:checkIfThrowItem()
 end

function BackpackManager:checkIfThrowItem()
    if self.keysBackpack[self.chosen] ~= nil then
        if love.keyboard.wasPressed('r') then
            self:removeStackItems()
        elseif love.keyboard.wasPressed('t') then
            self:removeOneItem()
        end
    end
end

function BackpackManager:removeStackItems()
    local itemName = self.keysBackpack[self.chosen]
    local itemNumber = self.content[itemName]
    self.content[itemName]  = nil
    table.remove(self.keysBackpack, self.chosen)
    local ix, iy = self:getDirItemCoords()
    while itemNumber > 0 do
        local delta = math.random(0, 5)
        gameMaps[activeMap].itemManager:addItem(itemName, ix+delta, iy+delta)
        itemNumber = itemNumber - 1
    end
end

function BackpackManager:removeOneItem()
    local itemName = self.keysBackpack[self.chosen]
    if self.content[itemName] == 1 then
        self:removeStackItems()
    else
        self.content[itemName] = self.content[itemName] - 1
        local ix, iy = self:getDirItemCoords()
        gameMaps[activeMap].itemManager:addItem(itemName, ix, iy)
    end
end

function BackpackManager:getDirItemCoords()
    local d, h, w = 10, player.height, player.width
    return player:getDirBasedCoordinates({{w, h/2}, {-d, h/2}, {w/2-d/2, 0}, {w/2-d/2, h}})
end

function BackpackManager:render()
    --love.graphics.setColor(132/255, 24/255 ,28/255)
    --love.graphics.rectangle('fill', (WINDOW_WIDTH / 2) - (CELL_WIDTH + 8) * 4 - 8, WINDOW_HEIGHT - CELL_WIDTH - 8, (CELL_WIDTH + 8) * 8 + 8, CELL_WIDTH + 16)
    --love.graphics.setColor(1, 1, 1)
    --
    --for i = 1, 8 do
    --    if i == self.chosen then
    --        love.graphics.setColor(225/255, 162/255, 104/255)
    --    end
    --    love.graphics.rectangle('fill', (WINDOW_WIDTH / 2) - (CELL_WIDTH + 8) * (4 - i + 1), WINDOW_HEIGHT - CELL_WIDTH, CELL_WIDTH, CELL_WIDTH)
    --    love.graphics.setColor(1, 1, 1)
    --end

    love.graphics.draw(BACKPACK_PANEL_IMG, WINDOW_WIDTH/2 - BACKPACK_PANEL_IMG:getWidth()/2, WINDOW_HEIGHT - BACKPACK_PANEL_IMG:getHeight())
    self:drawItemsOnPanel(WINDOW_HEIGHT - BACKPACK_PANEL_IMG:getHeight())

    if self.openBackpack then
        self:drawOpenedBackpack()
    end
end

function BackpackManager:drawItemsOnPanel(y)
    --local i = 1
    local addScale = 0
    local onScaleDiff = 0
    for i = 1, 10 do
        local name = self.keysBackpack[i]
        if name then
            --check if needed scaling
            if i == self.chosen then
                addScale = 0.2
                onScaleDiff = 2
            else
                addScale = 0
                onScaleDiff = 0
            end

            --draw item image
            love.graphics.draw(ITEMS_DEFS[name].image,
                    (WINDOW_WIDTH / 2) - CELL_WIDTH * (6 - i) + 8 - onScaleDiff,
                    y + 12 - onScaleDiff, nil, 2 + addScale)

            --print item count
            if self.content[name] > 1 then
                love.graphics.setColor(67/255, 48/255, 31/255)
                love.graphics.printf(tostring(self.content[name]),
                        (WINDOW_WIDTH / 2) - CELL_WIDTH * (6 - i) + CELL_WIDTH - 16,
                        y + BACKPACK_PANEL_IMG:getHeight() - 24, 18)
                love.graphics.setColor(1, 1, 1)
            end
        end
    end

    --draw frame on chosen item
    love.graphics.draw(BACKPACK_CHOSEN_IMG, (WINDOW_WIDTH / 2) - CELL_WIDTH * (6 - self.chosen) - 5, y + 4)
end

function BackpackManager:drawOpenedBackpack()
    love.graphics.draw(BACKPACK_IMG, WINDOW_WIDTH / 2 - BACKPACK_IMG:getWidth() / 2, WINDOW_HEIGHT / 2 - BACKPACK_IMG:getHeight() / 2)
    --self:drawItemsOnPanel(WINDOW_HEIGHT / 2 - BACKPACK_IMG:getHeight()/2)
    --draw frame on chosen item
    love.graphics.draw(BACKPACK_CHOSEN_IMG, (WINDOW_WIDTH / 2) - CELL_WIDTH * (6 - self.chosen) - 5, WINDOW_HEIGHT / 2 - BACKPACK_IMG:getHeight()/2 + 4)

    local mouseCellNow = self:getMouseCell()
    local addScale = 0
    local onScaleDiff = 0

    for j = 0, 3 do
        for i = 1, 10 do
            local curr_index = j*10 + i
            local name = self.keysBackpack[curr_index]

            if name then
                --check if needed scaling
                if mouseCellNow == curr_index or self.chosen == curr_index then
                    addScale = 0.2
                    onScaleDiff = 2
                else
                    addScale = 0
                    onScaleDiff = 0
                end

                --print item image
                love.graphics.draw(ITEMS_DEFS[name].image,
                WINDOW_WIDTH / 2 - BACKPACK_IMG:getWidth() / 2 + (i-1) * CELL_WIDTH + 14 - onScaleDiff,
                WINDOW_HEIGHT / 2 - BACKPACK_IMG:getHeight() / 2 + (j) * CELL_HEIGHT + 14 - onScaleDiff, nil, 2 + addScale)

                --draw item count
                if self.content[name] > 1 then
                love.graphics.setColor(67/255, 48/255, 31/255)
                love.graphics.printf(tostring(self.content[name]),
                        (WINDOW_WIDTH / 2) - CELL_WIDTH * (6 - i) + CELL_WIDTH - 16,
                        WINDOW_HEIGHT / 2 - BACKPACK_IMG:getHeight()/2 + (j) * CELL_HEIGHT + BACKPACK_PANEL_IMG:getHeight() - 24, 18)
                love.graphics.setColor(1, 1, 1)
            end
            end 
        end
    end
end

function BackpackManager:getMouseCell()
    local relativeX = mouseX - WINDOW_WIDTH / 2 + BACKPACK_IMG:getWidth() / 2 - 7
    local relativeY = mouseY - WINDOW_HEIGHT / 2 + BACKPACK_IMG:getHeight() / 2 - 7

    local cellX = math.ceil(relativeX/CELL_WIDTH)
    local cellY = math.ceil(relativeY/CELL_HEIGHT)

    love.graphics.print('mouseGridX: '.. cellX .. ' mouseGridY: '.. cellY, 0, 50)
    love.graphics.print('mouseGrid: '.. (cellY - 1)*10 + cellX, 0, 100)

    return (1 <= cellX and cellX <= 10) and (cellY - 1)*10 + cellX or 0
end