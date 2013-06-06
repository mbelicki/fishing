-- event.lua

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

-- Event implementation

-- TODO: event looks exactly like Command, consider mergeing
Event = class()

function Event:init(kind, args)
    for key, value in pairs(args) do
        --log(key, value)
        self[key] = value
    end
    self.kind = kind
end

-- factory functions

function evnHearingFrom(sender, receiver, text, role)
    return Event('hearingFrom', { sender = sender, receiver = receiver
                                , text = text, role = role
                                })
end

function evnReceivedItem(receiverId, itemId)
    return Event('receivedItem', {receiverId = receiverId, itemId = itemId})
end

function evnFullHour(h)
    return Event('fullHour', {hour = h})
end

function evnNightStart()
    return Event('nightBeginning')
end

function evnNightEnd()
    return Event('nightEnd')
end
