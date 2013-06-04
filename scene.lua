-- scene.lua

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
require 'utils'

require 'sprite'

-- Scene implementation:

Scene = class()

function Scene:init()
    -- set default values
    self.id            = 'id'
    self.width         = 1366
    self.height        = 600
    self.baselineLevel = 520
    self.hotSpots      = {};
    self.pointedItem   = "";
    self.time          = 0;
    self.nightColor    = {r = 77, g = 90, b = 111}
end

function Scene:setImage(path, filename)
    self.dayImage      = path .. '/' .. filename
    self.nightSkyImage = path .. '/ns-' .. filename
    self.daySkyImage   = path .. '/ds-' .. filename
end

function Scene:hotSpotAt(point)
    for key, value in pairs(self.hotSpots) do
        if isPointInRect(point, value) then
            return value;
        end
    end
    return nil
end

function Scene:update(dt)
    local events = {}
    self.time = getCurrentTime();
    -- self.time = self.time + dt
    -- if self.time > 24 then
    --     self.time = 0
    -- end
    for key, hotSpot in pairs(self.hotSpots) do
        local sprite = hotSpot.sprite
        if sprite ~= nil then
            sprite:update(dt)
        end
    end
    return events
end

function Scene:getDayAlpha()
    if self.time <= 6 or self.time >= 21 then
        return 0
    elseif self.time >= 7 and self.time <= 20 then
        return 1
    elseif self.time < 7 then
        return self.time - 6
    else
        return 1 - (self.time - 20)
    end
end

function Scene:getOverlayColor()
    local a = self:getDayAlpha()
    
    local r = lerp(self.nightColor.r, 255, a)
    local g = lerp(self.nightColor.g, 255, a)
    local b = lerp(self.nightColor.b, 255, a)
    
    return {r = r, g = g, b = b}
end

function Scene:draw(assets, translation)
    local daySkyAlpha = self:getDayAlpha()
    local overlay     = self:getOverlayColor()
    -- draw sky
    love.graphics.setColor(255, 255, 255, 255)
    if daySkyAlpha < 1 then
        love.graphics.draw(assets.sceneNightSky)
    end
    if daySkyAlpha > 0 then
        love.graphics.setColor(255, 255, 255, 255 * daySkyAlpha)
        love.graphics.draw(assets.sceneDaySky)
    end
    -- draw actual background
    love.graphics.setColor(overlay.r, overlay.g, overlay.b, 255)
    love.graphics.draw(assets.sceneBackground, -translation)

    for key, hotSpot in pairs(self.hotSpots) do
        local sprite = hotSpot.sprite
        if sprite ~= nil then
            local x = hotSpot.x - translation
            local y = hotSpot.y
            sprite:draw(x, y, assets)
        end
    end
end

-- a bunch of factory functions:

function CreateTestScene()
    local scene = Scene()
    scene:setImage('assets', 'scene0.png')
    scene.hotSpots[0] = { x = 239, y = 387, width = 53, height = 50
                        , name = "timetable"
                        , farDesc = "looks like some kind of timetable"
                        , nearDesc = "too bad, I have 4 hours till next bus"
                        }
    scene.hotSpots[1] = { x = 413, y = 461, width = 196, height = 34 
                        , name = "bench"
                        , farDesc = "an old bench"
                        , nearDesc = "no time for sitting"
                        }
    scene.hotSpots[2] = { x = 246, y = 185, width = 53, height = 75 
                        , name = "sign"
                        , farDesc = "this is definitely a bus stop"
                        , nearDesc = "actually, I really like the shape"
                        }

    --local spriteImgInfo = {name = 'assets/lady.png', width = 256 + 96, height = 256}
    --local sprite = Sprite( spriteImgInfo, {x = 161, y = 92}
    --                     , {width = 96, height = 164}, 1)
    --scene.hotSpots[3] = { x = 446, y = 350, width = 128, height = 128 
    --                    , sprite = sprite
    --                    , name = "sign"
    --                    , farDesc = "it's a woman, I think"
    --                    , nearDesc = "she looks old and tired"
    --                    }
    
    return scene
end

