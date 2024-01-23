local pda = {}
pda.__index = pda

local states = {"ready", "attacking", "stunned", "blocking", "dashing"}
local defaultState = "ready"
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

function pda.new(id, state)
    local self = {}
    
    self._id = id
    self._stack = {state or defaultState}    

    return setmetatable(self, pda)
end

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

function pda:destroy()
    pda[self] = nil
end

function pda:_isEmpty()
    return #self._stack == 0
end

function pda:push(v)
    table.insert(self._stack, v)
end

function pda:pop()
    if self._isEmpty() then
        return nil
    end

    return table.remove(self._stack, #self._stack)
end

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