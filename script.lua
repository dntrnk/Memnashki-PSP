local dofile = dofile
local systemGC = System.GC

System.HighCPU()

puzzle = {
    Image.load("src/sprites/puzzle1.png"),
    Image.load("src/sprites/puzzle2.png"),
    Image.load("src/sprites/puzzle3.png"),
    Image.load("src/sprites/puzzle4.png"),
    Image.load("src/sprites/puzzle5.png"),
    Image.load("src/sprites/puzzle6.png"),
    Image.load("src/sprites/puzzle7.png"),
    Image.load("src/sprites/puzzle8.png"),
    Image.load("src/sprites/puzzle9.png"),
    Image.load("src/sprites/puzzle10.png"),
    Image.load("src/sprites/puzzle11.png"),
    Image.load("src/sprites/puzzle12.png"),
    Image.load("src/sprites/puzzle13.png"),
    Image.load("src/sprites/puzzle14.png"),
    Image.load("src/sprites/puzzle15.png")
}

logoSprite = Image.load("src/sprites/logo.png")
supportSprite = Image.load("src/sprites/support.png")

image = 1
music = 1
nextScene = "src/scenes/madebydntrnk.lua"

while true do
    dofile(nextScene)
    systemGC()
end