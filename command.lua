-- command.lua

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
                            , text = text, role = role
                            })
end

-- TODO: perhaps this should be an event issiued by sender
function cmdAck(senderId, receiverId, eventType)
    return Command('ack', { senderId = senderId, receiverId = receiverId
                          , eventType = eventType
                          })
end

function cmdTryPickUp(itemId)
    return Command('pickup', {itemId = itemId})
end
