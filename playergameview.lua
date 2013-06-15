-- playergameview.lua

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
require 'gameview'
require 'interface'
require 'command'
require 'character'

-- PlayerGameView implementation:

PlayerGameView = class(GameView)

function PlayerGameView:init()
    self.interface = Interface()

    self.events = {hearingFrom = true, textFrom = true, recivedItem = true}

    local heroSprite = Sprite( {name = 'assets/hero.png', width = 256, height = 256}
                             , {x = 192, y = 128}
                             , {width = 64, height = 128}
                             , 1
                             )
    local heroPortrait = Sprite( {name = 'assets/hero.png', width = 256, height = 256}
                               , {x = 0, y = 0}
                               , {width = 179, height = 128}
                               , 1
                               )
    local hero = Character(heroSprite, heroPortrait, nil)

    -- TODO: perhaps extracting this into some kind of camera class might be
    --       helpful
    self.sceneViewTranslation = 0
    self.sceneViewMargin = 300

    self.hero = hero
end

-- @return: collection of Commands
function PlayerGameView:update(dt, currentScene)
    local commands = {}
    
    local mouse = {};
    mouse.x = love.mouse.getX();
    mouse.y = love.mouse.getY();
   
    local translatedMouse = {};
    translatedMouse.x = mouse.x + self.sceneViewTranslation;
    translatedMouse.y = mouse.y;
  
    local primaryDown   = love.mouse.isDown('l')
    local secondaryDown = love.mouse.isDown('r')

    if self.interface:requiresInteraction() then
        if primaryDown or secondaryDown then
            self.interface:dismissSpeechPopup()
        end
    end 
    

    if secondaryDown then
        table.insert(commands, cmdGoTo(translatedMouse.x))
    end 
    
    local hotSpot = currentScene:hotSpotAt(translatedMouse)
    
    if hotSpot ~= nil then
        mouse.kind = 'eye'
        if primaryDown then
            local id  = self.hero.id
            local cmd = cmdSayTo(id, id, hotSpot.farDesc, 'desc')
            table.insert(commands, cmd)
        end
    else
        mouse.kind = 'arrow'
    end

    self.hero:update(dt)
    self.interface:update(dt, mouse)

    return commands
end

-- @return: collection of event names
function PlayerGameView:handledEvents()
    return self.events
end

function PlayerGameView:handle(event)
    local kind = event.kind
    if kind == 'hearingFrom' then 
        self:handleHearing(event)
    else
        log('warning', 'unhandled event : ' .. event.kind)
    end
end

function PlayerGameView:handleHearing(event)
    self.interface:spawnSpeechPopup(event.text, event.sender.portrait)
end

-- @return: owned Character object
function PlayerGameView:ownedCharacter()
    return self.hero
end

function PlayerGameView:draw(assets, logic)
    self:updateSceneViewTranslation(logic.currentScene, assets.screen.width)
    logic.currentScene:draw(assets, self.sceneViewTranslation)
    
    local viewRange  = { leftBound  = self.sceneViewTranslation
                       , rightBound = self.sceneViewTranslation + assets.screen.width
                       }
    local characters = logic:getVisibleCharacters(logic.currentScene.id, viewRange)
    
    for _, character in pairs(characters) do
        local x = character.x - character.sprite.width / 2 - self.sceneViewTranslation
        local y = character.y - character.sprite.height
        character.sprite:draw(x, y, assets)
    end
    
    --love.graphics.setColor(255, 128, 128, 255)
    --local x = self.hero.x - self.hero.sprite.width / 2 - self.sceneViewTranslation;
    --local y = self.hero.y - self.hero.sprite.height;
    --love.graphics.rectangle("fill", x, y, self.hero.sprite.width, self.hero.sprite.height)
    
    self.interface:draw(assets)
end

function PlayerGameView:updateSceneViewTranslation(currentScene, screenWidth)
    local trans  = self.sceneViewTranslation
    local margin = self.sceneViewMargin

    local leftBorder  = trans
    local rightBorder = leftBorder + screenWidth
    
    local diffLeft  = self.hero.x - leftBorder
    local diffRight = rightBorder - self.hero.x

    if diffLeft < margin then
        trans = self.hero.x - margin
        if trans < 0 then
            trans = 0
        end
    elseif diffRight < margin then
        trans = self.hero.x - (screenWidth - margin) 
        if trans > currentScene.width - screenWidth then
            trans = currentScene.width - screenWidth
        end
    end
    
    self.sceneViewTranslation = trans
end

