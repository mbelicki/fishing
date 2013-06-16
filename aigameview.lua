-- aigameview.lua

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
require 'command'
require 'gameview'
require 'speechengine'

-- GameView abstract class definition:

AIGameView = class(GameView)

function AIGameView:init(boundCharacter)
    self.hero = boundCharacter
    self.events = { hearingFrom = true, textFrom = true, recivedItem = true
                  , fullHour = true
                  }
    self.pendingCommands = {}
    -- create generic instance of speach enginge
    self.speech = SpeechEngine()
    self.speech:createDefaultPredicates()
    self.speech:createDefaultGreetingRules()

    self.cachedTime = 0
end

-- @return: Command
function AIGameView:update(dt, currentScene)
    self.hero:update(dt)
    local commands = self.pendingCommands
    self.pendingCommands = {}

    if self.hero:isMoving() == false then
        if self.hero.destX ~= 550 then
            table.insert(commands, cmdGoTo(550))
        end
    end

    self.cachedTime = currentScene.time

    return commands
end

-- @return: collection of event names
function AIGameView:handledEvents()
    return self.events
end

function AIGameView:handle(event)
    -- TODO: obviously this is for testing only
    if event.kind == 'fullHour' then
        local cmd = cmdSayTo(self.hero.id, nil, 'it\'s ' .. event.hour, nil)
        table.insert(self.pendingCommands, cmd)
    elseif event.kind == 'hearingFrom' then
        local sender = event.sender
        log(self.hero.id, 'received message: "'..event.text..'" from: '..sender.id)
        
        if sender.id ~= self.hero.id then
            local statement = self:getStatement('greeting')
            local cmd = cmdSayTo(self.hero.id, sender.id, statement[1], statement[2])
            table.insert(self.pendingCommands, cmd)
        end
    end
end

function AIGameView:getStatement(role)
    local state = {time = self.cachedTime, requestedRole = role}
    local statements = self.speech:computeStatements(state)
    return statements[math.random( #statements)]
end

-- @return: owned Character object
function AIGameView:ownedCharacter()
    return self.hero
end
