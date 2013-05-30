-- main.lua

require 'gamelogic'
require 'playergameview'
require 'assets'

-- declarations:

local playerview = nil
local logic      = nil
local assets     = nil

-- actual interactions with love

function love.load()
    playerview = PlayerGameView()

    logic = GameLogic()
    logic:addView(playerview)

    assets = Assets()
    assets:loadSceneGraphics(logic.currentScene)
end

function love.update(dt)
    logic:update(dt)
end

function love.draw()
    playerview:draw(assets, logic.currentScene)
    
    love.graphics.setColor(255,128,128,255)
    local time = logic.currentScene.time
    love.graphics.print("time is " .. time, 8, 8)
end

