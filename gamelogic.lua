-- gamelogic.lua

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
require 'scene'
require 'event'
require 'aigameview'

-- methods only used for testing (TODO: build normal test suite later on)

local function spawnTestCharacters(logic)
    local spriteImgInfo = {name = 'assets/lady.png', width = 256 + 96, height = 256}
    local sprite = Sprite( spriteImgInfo, {x = 161, y = 92}
                         , {width = 96, height = 164}, 1)
    local portrait = Sprite( spriteImgInfo, {x = 0, y = 0}
                           , {width = 179, height = 128}, 1)
    local oldLady = Character(sprite, portrait)
    local view = AIGameView(oldLady)
    logic:addView(view)
end

-- parts of logic directly inaccessible from other modules

local function updateCharacter(character, dt)
    if character:isMoving() then
        if character.x > character.destX then
            character.x = character.x - character.speed * dt;
        elseif character.x < character.destX then
            character.x = character.x + character.speed * dt;
        end
    end
end

-- GameLogic implementation:

GameLogic = class()

function GameLogic:init()
    self.currentScene = CreateTestScene(self)
    self.gameViews = {}
    self.registeredCharacters = {}
    self.pendingEvents = {}

    spawnTestCharacters(self)
end

function GameLogic:update(dt)
    local events = self.currentScene:update(dt, self)
    for _, value in pairs(events) do
        table.insert(self.pendingEvents, value)
    end

    for _, view in pairs(self.gameViews) do
        local commands = view:update(dt, self.currentScene)
        for _, command in pairs(commands) do
            self:processCommand(command, view)
        end
    end
    
    for id, character in pairs(self.registeredCharacters) do
        updateCharacter(character, dt)
    end

    self:processEvents()
end

function GameLogic:processEvents()
    -- TODO: this surely can be optimized
    for _, event in pairs(self.pendingEvents) do
        local kind = event.kind
        local receiverId = event.receiverId
        
        for _, view in pairs(self.gameViews) do
            local handled = view:handledEvents()
            if handled[kind] then
                if receiverId ~= nil then 
                    if view.id == receiverId then
                        view:handle(event)
                    end
                else
                    view:handle(event)
                end
            end
        end
    end
    self.pendingEvents = {}
end

function GameLogic:processCommand(command, issuer)
    local kind = command.kind
    local character = issuer:ownedCharacter()

    if     kind == 'goto' then
        self:doGoTo(character, command.destination)
    elseif kind == 'sayto' then
        self:doSayTo(command)
    elseif kind == 'pickup' then
        log('warning', kind .. ' not implemented yet')
    else
        log('warning', 'unknown command: ' .. kind)
    end
end

function GameLogic:doGoTo(character, destination)
    character.destX = destination;
end

function GameLogic:doSayTo(cmd)
    local sender   = self.registeredCharacters[cmd.senderId]
    local receiver = self.registeredCharacters[cmd.receiverId]
    local event = evnHearingFrom(sender, cmd.text, cmd.role)
    table.insert(self.pendingEvents, event)
end

function GameLogic:getVisibleCharacters(sceneId, range)
    local visible = {}
    for _, character in pairs(self.registeredCharacters) do
        if character.sceneId == sceneId then
            local leftBound  = character.x - character.sprite.width / 2
            local rightBound = character.x - character.sprite.width / 2
            if leftBound > range.leftBound or rightBound < range.rightBound then 
                table.insert(visible, character)
            end
        end
    end
    return visible
end

function GameLogic:issueEvent(event)
    table.insert(self.pendingEvents, event)
end

function GameLogic:addView(view)
    local character = view:ownedCharacter()
    if character == nil then 
        log('warning', 'tried to add gameview without character')
        return 
    end

    self:registerCharacter(character)
    view.id = character.id -- sync ids, TODO: this is not very pretty
    character.y = self.currentScene.baselineLevel;
    character.x = 200 -- TODO: scene should contain some kind of spawn point
    character.destX = character.x
    if character.sceneId == nil then
        character.sceneId = self.currentScene.id   
    end

    table.insert(self.gameViews, view)
end

function GameLogic:registerCharacter(character)
    local t = self.registeredCharacters
    character.id = #t + 1
    t[character.id] = character
end

function GameLogic:characterAt(sceneId, point)
    for _, character in pairs(self.registeredCharacters) do
        if character.sceneId == sceneId then
            local rect = character:getRectangle()
            if isPointInRect(point, rect) then
                return character
            end
        end
    end
    return nil
end

