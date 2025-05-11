local screenClear = screen.clear
local buttonsRead = buttons.read
local buttonsPressed = buttons.pressed
local screenFlip = screen.flip

local random = math.random

local logo = logoSprite
local luaPrint = LUA.print

local imageDraw = Image.draw

local support = supportSprite

local puzzleNames = {
    "Тигр",
    "Чюпеп",
    "Денис-потеряшка", 
    "Андрей Евгеньевич",
    "Чувак",
    "Хомяк",
    "Чья-то тетрадь",
    "Учим геометрию на 5+",
    "Токийский дрифт",
    "Альцгеймер",
    "Свинья Клубниковна",
    "Шокирующие новости",
    "Первый раз не банворд",
    "KystanSkill собственной персоной",
    "Лимитированная карта"
}

local puzzleCount = #puzzleNames

while true do
    screenClear()

    buttonsRead()

    if buttonsPressed(buttons["left"]) then
        if image ~= 1 then
            image = image - 1
        end
    elseif buttonsPressed(buttons["right"]) then
        if image ~= puzzleCount then
            image = image + 1
        end
    elseif buttonsPressed(buttons["cross"]) then
        nextScene = "src/scenes/puzzle.lua"
        break
    elseif buttonsPressed(buttons["circle"]) then
        while true do
            screenClear()
            buttonsRead()
            if buttonsPressed(buttons["circle"]) then
                break
            end
            imageDraw(support, 64, 80)
            luaPrint(50, 50, "Поддержать автора монетой\nБуду чрезвычайно благодарен")
            luaPrint(210, 80, "Использована музыка:\nKahoot Lobby Theme\nKevin MacLeod - The Builder\nKevin MacLeod - Secret of Tiki Island\nДантрон Иллюминатор - Робот в казино\n(Instrumental)\nКак достать соседа Микс 2 - Меню")
            luaPrint(200, 200, "O - Вернуться в меню")
            screenFlip()
        end
    end

    imageDraw(logo, 175, 16)

    luaPrint(188, 48, "Выбери картинку")
    if image == 10 then
        if random(10) < 5 then
            luaPrint(192, 206, "##########")
        else
            luaPrint(192, 206, puzzleNames[image])
        end
    else
        luaPrint(192, 206, puzzleNames[image])
    end

    luaPrint(202, 226, "Х - Начать")

    luaPrint(16, 210, "Автор: @dntrnk")

    luaPrint(16, 230, "Следи за новостями:\nt.me/pspdevlogdntrnk")

    luaPrint(330, 230, "О - Авторы")
    luaPrint(440, 250, "v1.0")

    imageDraw(puzzle[image], 176, 72, 128, 128)

    screenFlip()
end
