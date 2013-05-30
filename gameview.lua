-- gameview.lua

require 'class'

-- GameView abstract class definition:

GameView = class()

function GameView:init()
end

-- @return: Command
function GameView:update(dt, currentScene)
    return nil
end

-- @return: collection of event names
function GameView:handledEvents()
    return {}
end

function GameView:handle(event)
end

-- @return: owned Character object
function GameView:ownedCharacter()
    return nil
end
