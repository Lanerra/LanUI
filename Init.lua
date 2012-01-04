local LanUI, Engine = ...
Engine[1] = {} -- LanFunc
Engine[2] = {} -- LanConfig
Engine[3] = {} -- LanLocal

LanUI = Engine

--[[ This goes at the top of everything, silly!
        local LanFunc, LanConfig, LanLocal = unpack(select(2, ...))
]]