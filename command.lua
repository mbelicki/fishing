-- command.lua

require 'class'

-- Command implementation

Command = class()

function Command:init(kind, args)
    for key, value in pairs(args) do
        self[key] = value
    end
    self.kind = kind
end

-- Commnad related factory functions:

function cmdGoTo(x)
    return Command('goto', {destination = x})
end

function cmdSayTo(senderId, receiverId, text, role)
    -- TODO: validate role here?
    return Command('sayto', { senderId = senderId, receiverId = receiverId
                            , text = text, role = role})
end

function cmdTryPickUp(itemId)
    return Command('pickup', {itemId = itemId})
end
