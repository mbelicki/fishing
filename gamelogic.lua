-- gamelogic.lua

require 'class'
require 'scene'
require 'event'

-- parts of logic directly inaccessible from other modules

local function updateCharacter(character, dt)
    if math.abs(character.x - character.destX) > character.destEps then
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
    self.currentScene = CreateTestScene()
    self.gameViews = {}
    self.registeredCharacters = {}
    self.pendingEvents = {}
end

function GameLogic:update(dt)
    local events = self.currentScene:update(dt)
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
    local event = evnHearingFrom( cmd.senderId, cmd.receiverId
                                , cmd.text, cmd.role
                                )
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
    table.insert(self.gameViews, view)
end

function GameLogic:registerCharacter(character)
    local t = self.registeredCharacters
    character.id = #t + 1
    t[character.id] = character
end

