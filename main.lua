local pda = {}
pda.__index = pda

--[[
    An array of states, used for validating if a state exists before entering it.
    This is not provided in the module, so you will need to implement it yourself!
]]
local states = {"ready", "attacking", "stunned", "blocking", "dashing"}
local defaultState = "ready"

--[[
    A dictionary of transitions, from each state, to every state. 
    it is important to EXCLUDE transition functions for states you do NOT want
    to be transitionable if the character is in a certain state.
    For example, a character can only transition to the "ready" or "stunned" state 
    if it is in the attacking state. This is intentional!
]]
local transitions = {
    ["ready"] = {
        ["attacking"] = function(machine, currentState, newState, ...)            
            print("Character is attacking!")
        end,
        ["stunned"] = function(machine, currentState, newState, ...)            
            print("Character is stunned!")
        end,
        ["blocking"] = function(machine, currentState, newState, ...)            
            print("Character is blocking!")
        end,
        ["dashing"] = function(machine, currentState, newState, ...)            
            print("Character is dashing!")
        end,
    },
    ["attacking"] = {
        ["ready"] = function(machine, currentState, newState, ...)            
            print("Character is ready!")
        end,
        ["stunned"] = function(machine, currentState, newState, ...)            
            print("Character is stunned!")
        end,
    },
    ["stunned"] = {
        ["ready"] = function(machine, currentState, newState, ...)            
            print("Character is ready!")
        end        
    },
    ["blocking"] = {
        ["ready"] = function(machine, currentState, newState, ...)            
            print("Character is ready!")
        end,
    },
    ["dashing"] = {
        ["ready"] = function(machine, currentState, newState, ...)            
            print("Character is ready!")
        end,
    }
}

--[[
    Constructor, a uid is a unique identifier. It is needed if you intend to have multiple
    instances of the PDA, which will likely be the case. It is imperative to create your
    own uid generating logic, as this is not provided in the module.
]]
function pda.new(uid, state)
    local self = {}
    
    self._id = uid
    self._stack = {state or defaultState}    

    return setmetatable(self, pda)
end

--[[
    State updater function. Can provide optional arguments to be passed 
    along for use in the transition function.
]]
function pda:set(input, ...)
    local stack = self._stack
    local current, stateTransition

    current = stack[#stack]
    stateTransition = transitions[current][input]

    if stateTransition and current ~= input then
        self:push(input)
        stateTransition(self, current, input, ...)
        return true
    end

    print("Character cannot enter that state!")

    return false
end

-- Destroys the reference to the PDA, rendering it unusable and eligible for garbage collection.
function pda:destroy()
    pda[self] = nil
end

-- Used internally to determine if the stack is empty, before performing operations on it
function pda:_isEmpty()
    return #self._stack == 0
end

-- Used internally to update the stack, inserts an element to the top of the stack
function pda:push(v)
    table.insert(self._stack, v)
end

-- Used internally to update the stack, removes and returns the top-most element
function pda:pop()
    if self._isEmpty() then
        return nil
    end

    return table.remove(self._stack, #self._stack)
end

-- Used internally to update the stack, removes and returns the bottom-most element
function pda:shift()
    if self._isEmpty() then
        return nil
    end

    return table.remove(self._stack, 1)
end

-- Test Code
local myPDA = pda.new("some-id-256", "ready")
myPDA:set("stunned")
myPDA:set("stunned")
myPDA:set("ready")
myPDA:set("attacking")
myPDA:set("dashing")
myPDA:set("ready")
myPDA:set("blocking")
myPDA:set("ready")
myPDA:set("dashing")
myPDA:set("ready")