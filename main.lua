-- main.lua

-- Copyright (C) 2013 Mateusz Belicki
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to
-- deal in the Software without restriction, including without limitation the
-- rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
-- sell copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
-- IN THE SOFTWARE.

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

