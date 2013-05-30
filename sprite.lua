-- sprite.lua

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

-- Sprite implementation:

Sprite = class()

function Sprite:init(imageInfo, gridOffset, gridSize, frameCount)
     -- init quads
     local w = gridSize.width
     local h = gridSize.height
     local aW = imageInfo.width
     local aH = imageInfo.height
     self.imageInfo = imageInfo
     self.quads = {}

     for i = 0, frameCount - 1 do
         local x = gridOffset.x + gridSize.width * i
         local y = gridOffset.y
         local quad = love.graphics.newQuad(x, y, w, h, aW, aH)
         self.quads[i] = quad
     end
     -- init timer
     self.frameTimer  = 0
     self.framePeriod = 0.25

     self.currentFrame = 0
     self.framesCount  = frameCount

     self.isStatic = self.framesCount == 1
end

function Sprite:getFrameTime()
    return self.framePeriod
end

function Sprite:update(dt)
    if self.isStatic then return end

    self.frameTimer = self.frameTimer + dt
    if self.frameTimer >= self.framePeriod then 
        self.frameTimer = 0
        self.currentFrame = self.currentFrame + 1
        if self.currentFrame >= self.framesCount then
            self.currentFrame = 0
        end
    end
end

function Sprite:draw(x, y, assets)
    local quad = self.quads[self.currentFrame]
    local texture = assets:getImage(self.imageInfo.name)
    love.graphics.drawq(texture, quad, x, y)
end
