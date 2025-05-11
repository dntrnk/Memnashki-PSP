-- Инициализация
local screenWidth = 480
local screenHeight = 272
local puzzleSize = 64 -- Размер каждого пазла (256 / 4 = 64)
local gridSize = 4 -- Количество пазлов по горизонтали и вертикали (4x4)
local puzzles = {} -- Массив для хранения пазлов
local emptyX = gridSize -- Позиция пустой клетки по X
local emptyY = gridSize -- Позиция пустой клетки по Y
local completed = false -- Флаг завершения игры
local cursorX = 1 -- Позиция курсора по X
local cursorY = 1 -- Позиция курсора по Y
local time = 0 -- Время для анимации фона
local animationSpeed = 0.1 -- Скорость анимации перемещения пазлов
local movingPuzzle = nil -- Пазл, который сейчас перемещается
local startX, startY = 0, 0 -- Начальная позиция для анимации
local targetX, targetY = 0, 0 -- Целевая позиция для анимации
local progress = 0 -- Прогресс анимации (от 0 до 1)

local loop = true

local luaGetRandom = LUA.getRandom
local luaPrint = LUA.print
local random = math.random
local abs = math.abs
local tableInsert = table.insert

local screenClear = screen.clear
local buttonsRead = buttons.read
local buttonsPressed = buttons.pressed
local imageDraw = Image.draw
local screenDrawRect = screen.drawRect
local screenFlip = screen.flip
local ipairs = ipairs

local cWhite = Color.new(255, 255, 255)
local cBlack = Color.new(0, 0, 0)

-- Загрузка изображения
local sprite = puzzle[image]

-- Разбиение изображения на пазлы
for y = 1, gridSize do
    for x = 1, gridSize do
        if x ~= gridSize or y ~= gridSize then -- Пропускаем последнюю клетку (пустую)
            local puzzle = {
                x = x, -- Исходная позиция по X
                y = y, -- Исходная позиция по Y
                currentX = x, -- Текущая позиция по X
                currentY = y, -- Текущая позиция по Y
                srcX = (x - 1) * puzzleSize, -- Начало захвата текстуры по X
                srcY = (y - 1) * puzzleSize, -- Начало захвата текстуры по Y,
            }
            tableInsert(puzzles, puzzle)
        end
    end
end

-- Функция для перемешивания пазлов
local function shufflePuzzles()
    local directions = {
        {dx = 1, dy = 0},  -- Вправо
        {dx = -1, dy = 0}, -- Влево
        {dx = 0, dy = 1},  -- Вниз
        {dx = 0, dy = -1}, -- Вверх,
    }

    -- Выполняем 1000 случайных ходов
    for i = 1, 1000 do
        -- Выбираем случайное направление
        local dir = directions[random(1, 4)]
        local newX = emptyX + dir.dx
        local newY = emptyY + dir.dy

        -- Проверяем, что новая позиция находится в пределах поля
        if newX >= 1 and newX <= gridSize and newY >= 1 and newY <= gridSize then
            -- Меняем местами пазл и пустую клетку
            for _, puzzle in ipairs(puzzles) do
                if puzzle.currentX == newX and puzzle.currentY == newY then
                    puzzle.currentX, puzzle.currentY = emptyX, emptyY
                    emptyX, emptyY = newX, newY
                    break
                end
            end
        end
    end
end

-- Перемешиваем пазлы
shufflePuzzles()

-- Функция для проверки завершения игры
local function checkCompletion()
    for _, puzzle in ipairs(puzzles) do
        if puzzle.x ~= puzzle.currentX or puzzle.y ~= puzzle.currentY then
            return false
        end
    end
    return true
end

-- Вычисление начальной позиции поля для центрирования
local fieldWidth = gridSize * puzzleSize
local fieldHeight = gridSize * puzzleSize
local fieldX = (screenWidth - fieldWidth) / 2 -- Центрирование по X
local fieldY = (screenHeight - fieldHeight) / 2 -- Центрирование по Y

-- Функция для линейной интерполяции (LERP)
local function lerp(start, finish, progress)
    return start + (finish - start) * progress
end

sound.play("src/music/ingame" .. tostring(music) .. ".mp3", sound.MP3, false, true)

-- Основной игровой цикл
while loop do
    screenClear()
    -- Обновление состояния кнопок
    buttonsRead()

    -- Отрисовка пазлов
    for _, puzzle in ipairs(puzzles) do
        if puzzle.currentX ~= emptyX or puzzle.currentY ~= emptyY then
            local drawX = fieldX + (puzzle.currentX - 1) * puzzleSize
            local drawY = fieldY + (puzzle.currentY - 1) * puzzleSize

            -- Если пазл перемещается, вычисляем промежуточную позицию
            if movingPuzzle == puzzle then
                drawX = lerp(startX, targetX, progress)
                drawY = lerp(startY, targetY, progress)
                progress = progress + animationSpeed

                -- Если анимация завершена, обновляем позицию пазла
                if progress >= 1 then
                    puzzle.currentX, puzzle.currentY = emptyX, emptyY
                    emptyX, emptyY = cursorX, cursorY
                    movingPuzzle = nil
                    progress = 0
                end
            end

            imageDraw(sprite, drawX, drawY, puzzleSize, puzzleSize, cWhite, puzzle.srcX, puzzle.srcY, puzzleSize, puzzleSize)
        end
    end

    imageDraw(sprite, 24, 32, 64, 64)

    -- Отрисовка чёрной обводки для курсора
    local cursorDrawX = fieldX + (cursorX - 1) * puzzleSize
    local cursorDrawY = fieldY + (cursorY - 1) * puzzleSize
    screenDrawRect(cursorDrawX, cursorDrawY, puzzleSize, 1, cWhite)
    screenDrawRect(cursorDrawX, cursorDrawY + 63, puzzleSize, 1, cWhite)
    screenDrawRect(cursorDrawX, cursorDrawY, 1, puzzleSize, cWhite)
    screenDrawRect(cursorDrawX + 63, cursorDrawY, 1, puzzleSize, cWhite)

    -- Управление
    if not movingPuzzle then
        if buttonsPressed(buttons["up"]) then
            if cursorY > 1 then
                cursorY = cursorY - 1
            end
        end
        if buttonsPressed(buttons["down"]) then
            if cursorY < gridSize then
                cursorY = cursorY + 1
            end
        end
        if buttonsPressed(buttons["left"]) then
            if cursorX > 1 then
                cursorX = cursorX - 1
            end
        end
        if buttonsPressed(buttons["right"]) then
            if cursorX < gridSize then
                cursorX = cursorX + 1
            end
        end

        -- Перемещение пазла в пустую клетку
        if buttonsPressed(buttons["cross"]) then
            local dx = cursorX - emptyX
            local dy = cursorY - emptyY
            if (abs(dx) == 1 and dy == 0) or (abs(dy) == 1 and dx == 0) then
                -- Находим пазл под курсором
                for _, puzzle in ipairs(puzzles) do
                    if puzzle.currentX == cursorX and puzzle.currentY == cursorY then
                        movingPuzzle = puzzle
                        startX = fieldX + (puzzle.currentX - 1) * puzzleSize
                        startY = fieldY + (puzzle.currentY - 1) * puzzleSize
                        targetX = fieldX + (emptyX - 1) * puzzleSize
                        targetY = fieldY + (emptyY - 1) * puzzleSize
                        break
                    end
                end
            end
        end
    end

    -- Проверка завершения игры
    if checkCompletion() then
        completed = true
        break
    end

    luaPrint(371, 20, "O - Выйти в меню")    

    -- Вывод на экран
    screenFlip()

    if buttonsPressed(buttons["circle"]) then
        while true do
            screenClear()

            buttonsRead()

            if buttonsPressed(buttons["cross"]) then
                loop = false
                break
            elseif buttonsPressed(buttons["circle"]) then
                break
            end

            if luaGetRandom(20) < 6 then
                luaPrint(200, 100, "Сосал?\nХ - Да   O - Нет")
            else
                luaPrint(200, 100, "Ты точно хочешь выйти в меню?\nX - Да   O - Нет")
            end

            screenFlip()
        end
    end
end

-- Завершение игры
if completed then
    screenClear(Color.new(0, 255, 0))
    screenFlip()
end

if music == 5 then
    music = 1
else
    music = music + 1
end

sound.stop(sound.MP3)

nextScene = "src/scenes/menu.lua"
