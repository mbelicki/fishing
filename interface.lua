-- interface.lua

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

-- SpeechPopup implementation:

SpeechPopup = class()

function SpeechPopup:init(text, portraitSprite)
    self.text = text
    self.portrait = portraitSprite

    self.fadePeriod = 0.25
    self.fadeTimer  = self.fadePeriod
    self.fadeMode   = "in"

    self.width        = 420
    self.height       =  58
    self.bottomMargin =  40
    self.padding      =   8

    self.bgColor = {r =  44, g =  52, b =  64, a = 220}
    self.fgColor = {r = 255, g = 255, b = 255, a = 240}
end

function SpeechPopup:update(dt)
    if self.fadeTimer > 0 then
        self.fadeTimer = self.fadeTimer - dt
        if self.fadeTimer < 0 then
            self.fadeTimer = 0
        end
    end
end

function SpeechPopup:isFading()
    return self.fadeTimer ~= 0
end

function SpeechPopup:isInvisible()
    return self:getCurrentAlpha() == 0
end

function SpeechPopup:fadeOut()
    self.fadeMode = "out"
    self.fadeTimer  = self.fadePeriod
end

function SpeechPopup:getCurrentAlpha()
    if self.fadeTimer == 0 
    and self.fadeMode ~= "out" 
    then return 1 end

    local t = self.fadeTimer / self.fadePeriod
    if self.fadeMode == "in" then 
        return 1 - t
    elseif self.fadeMode == "out" then
        return t
    else
        return 0
    end
end

function SpeechPopup:draw(assets)
    local alpha = self:getCurrentAlpha()
    local x = (assets.screen.width - self.width) / 2
    local y = assets.screen.height - self.height - self.bottomMargin
    -- draw background
    love.graphics.setColor( self.bgColor.r , self.bgColor.g
                          , self.bgColor.b , self.bgColor.a * alpha
                          )
    love.graphics.rectangle("fill", x, y, self.width, self.height)
    -- draw foreground
    y = y + self.padding * 2
    love.graphics.setColor( self.fgColor.r , self.fgColor.g
                          , self.fgColor.b , self.fgColor.a * alpha
                          )
    love.graphics.printf(self.text, x, y, self.width, "center")

    if self.portrait ~= nil then
        love.graphics.setColor(255, 255, 255, 255 * alpha)
        self.portrait:draw(x - 148, y - 64, assets)
    end
end

-- Interface implementation:

Interface = class()

function Interface:init()
    self.speechPopup = nil
end

function Interface:spawnSpeechPopup(text, portrait)
    self.speechPopup = SpeechPopup(text, portrait)
end

function Interface:dismissSpeechPopup()
    if self.speechPopup ~= nil then
        if self.speechPopup:isInvisible() then
            self.speechPopup = nil
        elseif false == self.speechPopup:isFading() then
            self.speechPopup:fadeOut()
        end 
    end
end

function Interface:requiresInteraction()
    return self.speechPopup ~= nil
end

function Interface:update(dt)
    if self.speechPopup ~= nil then
        self.speechPopup:update(dt)
        if self.speechPopup:isInvisible() then
            self.speechPopup = nil
        end
    end
end

function Interface:draw(assets)
    if self.speechPopup ~= nil then
        self.speechPopup:draw(assets)
    end
end
