-- character.lua

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

require 'sprite'

-- Character implementation:

Character = class()

function Character:init(sprite, portraitSprite, currentSceneId)
    self.x = 0 
    self.y = 0
    self.id = 'hero'
    self.destX   = self.x
    self.destEps = 4
    self.speed   = 200
    self.sprite   = sprite
    self.portrait = portraitSprite
    self.sceneId  = currentSceneId
end

function Character:getRectangle()
    return { x = self.x, y = self.y
           , width = self.sprite.width
           , height = self.sprite.height
           }
end

function Character:isMoving()
    return math.abs(self.x - self.destX) > self.destEps
end

function Character:update(dt)
    self.sprite:update(dt)
end
