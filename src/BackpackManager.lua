BackpackManager = Class{}

CELL_WIDTH = 48
CELL_HEIGHT = 48
BACKPACK_IMG = love.graphics.newImage('images/backpack2.png')
BACKPACK_PANEL_IMG = love.graphics.newImage('images/backpack-panel.png')
BACKPACK_CHOSEN_IMG = love.graphics.newImage('images/backpack-chosen.png')
BACKPACK_IN_ROW = 10

BACKPACK_CAPACITY = 40

function BackpackManager:init(backpack)
    self.content = backpack
    self.chosen = 1
    --self.keysPanel = {}

    self.openBackpack = false
    self.keysBackpack = {}

    self.taken = nil
end

function BackpackManager:update(dt)
    if love.keyboard.wasPressed('a') then
        self.chosen = self.chosen < 2 and 10 or self.chosen - 1
    end
    if love.keyboard.wasPressed('d') then
        self.chosen = self.chosen > 9 and 1 or self.chosen + 1
    end
    if love.keyboard.wasPressed('b') then
        if self.openBackpack and self.taken then
            self.keysBackpack[self.fromCell] = self.taken
            self.taken = nil
            self.fromCell = nil
        end
        self.openBackpack = not self.openBackpack
    end

    for name, _ in pairs(self.content) do
        if name ~= self.taken and not table.contains(self.keysBackpack, name) then
            local firstnil = self:findNilInBackPack()
            if firstnil then
                self.keysBackpack[firstnil] = name
            else
                love.graphics.print("Backpack riches the limit", WINDOW_WIDTH/2 - BACKPACK_PANEL_IMG:getWidth()/2, WINDOW_HEIGHT - BACKPACK_PANEL_IMG:getHeight() - 12)
            end
        end
    end
    player:updateHoldingItem(self.keysBackpack[self.chosen])
    self:checkIfThrowItem()

    self:checkForTaking()
 end

function BackpackManager:render()
    love.graphics.draw(BACKPACK_PANEL_IMG, love.graphics.getWidth()/2 - BACKPACK_PANEL_IMG:getWidth()/2, love.graphics.getHeight() - BACKPACK_PANEL_IMG:getHeight())
    self:drawItemsOnPanel(love.graphics.getHeight() - BACKPACK_PANEL_IMG:getHeight())

    if self.openBackpack then
        self:drawOpenedBackpack()
        if self.taken then
            self:drawTakenItem()
        end
    end

    --if love.mouse.isDown(1) then
    --    love.graphics.print('mouse: '.. tostring(self.mouse_test[1]) .. tostring(self.mouse_test[2]), 0, 150)
    --end
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
    self.keysBackpack[self.chosen] = nil
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

function BackpackManager:checkForTaking()
    if self.openBackpack then
        if not self.taken then
            if love.mouse.buttonsPressed[1] then
                local x = love.mouse.buttonsPressed[1][1]
                local y = love.mouse.buttonsPressed[1][2]
                --take item
                self.fromCell = self:getMouseCell(x, y)
                if self.keysBackpack[self.fromCell] then
                    self.taken = self.keysBackpack[self.fromCell]
                    self.keysBackpack[self.fromCell] = nil
                end
            end
        else
            if love.mouse.buttonsPressed[1] then
                local x = love.mouse.buttonsPressed[1][1]
                local y = love.mouse.buttonsPressed[1][2]
                self.toCell = self:getMouseCell(x, y)

                if self.toCell ~= 0 then
                    --put item
                    if self.keysBackpack[self.toCell] then
                        self.keysBackpack[self.fromCell] = self.keysBackpack[self.toCell]
                    else
                        self.keysBackpack[self.fromCell] = nil
                    end
                    self.keysBackpack[self.toCell] = self.taken

                    --delete all
                    self.taken = nil
                    self.toCell = nil
                    self.fromCell = nil
                end
            end
        end
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
                    (love.graphics.getWidth() / 2) - CELL_WIDTH * (6 - i) + 8 - onScaleDiff,
                    y + 14 - onScaleDiff, nil, 2 + addScale)

            --print item count
            if self.content[name] > 1 then
                love.graphics.setColor(67/255, 48/255, 31/255)
                love.graphics.printf(tostring(self.content[name]),
                        (love.graphics.getWidth() / 2) - CELL_WIDTH * (6 - i) + CELL_WIDTH - 16,
                        y + BACKPACK_PANEL_IMG:getHeight() - 24, 18)
                love.graphics.setColor(1, 1, 1)
            end
        end
    end

    --draw frame on chosen item
    love.graphics.draw(BACKPACK_CHOSEN_IMG, (love.graphics.getWidth() / 2) - CELL_WIDTH * (6 - self.chosen) - 5, y + 4)
end

function BackpackManager:drawOpenedBackpack()
    love.graphics.draw(BACKPACK_IMG, love.graphics.getWidth() / 2 - BACKPACK_IMG:getWidth() / 2, love.graphics.getHeight() / 2 - BACKPACK_IMG:getHeight() / 2)
    --self:drawItemsOnPanel(WINDOW_HEIGHT / 2 - BACKPACK_IMG:getHeight()/2)
    --draw frame on chosen item
    love.graphics.draw(BACKPACK_CHOSEN_IMG, (love.graphics.getWidth() / 2) - CELL_WIDTH * (6 - self.chosen) - 5, love.graphics.getHeight() / 2 - BACKPACK_IMG:getHeight()/2 + 4)

    local mouseCellNow = self:getMouseCell(mouseX, mouseY)
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
                love.graphics.getWidth() / 2 - BACKPACK_IMG:getWidth() / 2 + (i-1) * CELL_WIDTH + 14 - onScaleDiff,
                love.graphics.getHeight() / 2 - BACKPACK_IMG:getHeight() / 2 + (j) * CELL_HEIGHT + 14 - onScaleDiff, nil, 2 + addScale)

                --draw item count
                if self.content[name] > 1 then
                love.graphics.setColor(67/255, 48/255, 31/255)
                love.graphics.printf(tostring(self.content[name]),
                        (love.graphics.getWidth() / 2) - CELL_WIDTH * (6 - i) + CELL_WIDTH - 16,
                        love.graphics.getHeight() / 2 - BACKPACK_IMG:getHeight()/2 + (j) * CELL_HEIGHT + BACKPACK_PANEL_IMG:getHeight() - 24, 18)
                love.graphics.setColor(1, 1, 1)
            end
            end 
        end
    end
end

function BackpackManager:drawTakenItem()
    love.graphics.draw(ITEMS_DEFS[self.taken].image, mouseX - CELL_WIDTH/4, mouseY - CELL_HEIGHT/4, nil, 2)
end
function BackpackManager:getMouseCell(x, y)
    local relativeX = x - love.graphics.getWidth() / 2 + BACKPACK_IMG:getWidth() / 2 - 7
    local relativeY = y - love.graphics.getHeight() / 2 + BACKPACK_IMG:getHeight() / 2 - 7

    local cellX = math.ceil(relativeX/CELL_WIDTH)
    local cellY = math.ceil(relativeY/CELL_HEIGHT)

    --love.graphics.print('mouseGridX: '.. cellX .. ' mouseGridY: '.. cellY, 0, 50)
    --love.graphics.print('mouseGrid: '.. (cellY - 1)*10 + cellX, 0, 100)

    return (1 <= cellX and cellX <= 10 and 1 <= cellY and cellY <= 4) and (cellY - 1)*10 + cellX or 0
end

function BackpackManager:findNilInBackPack()
    local wherenil = nil
    for i = 1, BACKPACK_CAPACITY do
        if not self.keysBackpack[i] then
            wherenil = i
            break
        end
    end
    return wherenil
end