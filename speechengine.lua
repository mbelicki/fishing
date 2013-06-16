-- speachengine.lua

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

-- SpeachEngine implementation:

SpeechEngine = class()

function SpeechEngine:init()
    self.predicates = {} -- id : predicate
    self.evaluation = {} -- id : bool -- result of evaluated predicates
    self.rules = {} -- [predicate ids] : [text, [tags]]
end

function SpeechEngine:createDefaultPredicates()
    self.predicates['isDay'] = function (state) 
        return state.time > 6.5 and state.time < 20.5
    end
    self.predicates['isNight'] = function (state) 
        return state.time < 6.5 or state.time > 20.5
    end
    self.predicates['isMorning'] = function (state)
        return state.time > 6.5 and state.time < 11.5
    end
    self.predicates['isAfternoon'] = function (state)
        return state.time > 12.5 and state.time < 16.5
    end
    self.predicates['isEvening'] = function (state)
        return state.time > 16.5 and state.time < 23.5
    end

    self.predicates['isGreeting'] = function (state)
        return state.requestedRole == 'greeting'
    end
end

function SpeechEngine:createDefaultGreetingRules()
    self.rules[{'isGreeting', }]              = {"hello", {"greeting", "casual"}}
    self.rules[{'isGreeting', }]              = {"hi", {"greeting", "casual"}}
    self.rules[{'isGreeting', }]              = {"hi there", {"greeting", "casual"}}
    self.rules[{'isGreeting', }]              = {"welcome", {"greeting", "formal"}}
    self.rules[{'isGreeting', 'isNight'}]     = {"good night", {"greeting", "formal"}}
    self.rules[{'isGreeting', 'isMorning'}]   = {"good morning", {"greeting", "formal"}}
    self.rules[{'isGreeting', 'isAfternoon'}] = {"good afternoon", {"greeting", "formal"}}
    self.rules[{'isGreeting', 'isEvening'}]   = {"good evening", {"greeting", "formal"}}
end

function SpeechEngine:evaluateConditions(conditions, state)
    for _, predicateId in pairs(conditions) do
        local evaled = self.evaluation[predicateId]
        
        if evaled == nil then
            local predicate = self.predicates[predicateId]
            evaled = predicate(state)
            self.evaluation[predicateId] = evaled
        end

        if evaled == false then return false end
    end
    return true
end

function SpeechEngine:computeStatements(state)
    local statements = {}
    self.evaluation = {} -- reset cached predicates evaluation
    for conditions, rule in pairs(self.rules) do
        local condMet = self:evaluateConditions(conditions, state)
        if condMet then table.insert(statements, rule) end
    end
    return statements
end
