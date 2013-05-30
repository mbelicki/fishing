-- event.lua

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

function evnHearingFrom(senderId, receiverId, text, role)
    return Event('hearingFrom', { senderId = senderId, receiverId = receiverId
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
