-- assets.lua

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

require 'class'

-- Assets implementation:

Assets = class()

function Assets:init()
    self.screen = {}
    self.screen.width  = 800
    self.screen.height = 600

    self.dialogFont = love.graphics.newImageFont("assets/inconsolata22.png",
                                        " abcdefghijklmnopqrstuvwxyz" ..
                                        "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" .. 
                                        "123456789.,!?-+/():;%&`'*#=[]\"")
    love.graphics.setFont(self.dialogFont)

    self.sceneBackground = nil
    self.sceneNightSky   = nil
    self.sceneDaySky     = nil

    self.imageBuffer = {}
end

function Assets:loadSceneGraphics(scene)
    local img = love.graphics.newImage

    self.sceneBackground = img(scene.dayImage);
    self.sceneNightSky   = img(scene.nightSkyImage);
    self.sceneDaySky     = img(scene.daySkyImage);
end

function Assets:clearImageBuffer()
    -- this is said to unload images, but I haven't checked if it works
    self.imageBuffer = nil
    collectgarbage('collect')
    self.imageBuffer = {}
end

function Assets:getImage(path)
    local image = self.imageBuffer[path]
    if image == nil then
        log('info', "loading : " .. path .. "\n")
        image = love.graphics.newImage(path)
        image:setFilter('nearest', 'nearest')
        self.imageBuffer[path] = image
    end
    return image
end
