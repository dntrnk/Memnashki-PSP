local soundPlay = sound.play
local screenClear = screen.clear
local imageDraw = Image.draw
local screenFlip = screen.flip
local imageLoad = Image.load
local imageUnload = Image.unload

local dntrnk = imageLoad("src/sprites/dntrnk.jpg")
local dntrnkText = imageLoad("src/sprites/dntrnkText.png")

nextScene = "src/scenes/menu.lua"

soundPlay("src/music/dntrnk.mp3", sound.MP3, false, false)

for i = 1, 200 do
    screenClear()

    imageDraw(dntrnk, 176, 72)
    imageDraw(dntrnkText, 198, 216)

    screenFlip()
end

imageUnload(dntrnk)
imageUnload(dntrnkText)
