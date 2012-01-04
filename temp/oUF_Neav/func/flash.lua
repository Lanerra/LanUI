
local _, ns = ...

local flashObjects = {}
local f = CreateFrame('Frame')

local function Flash_OnUpdate(self, elapsed)
    local frame
    local index = #flashObjects

    while flashObjects[index] do
        frame = flashObjects[index]
        frame.flashTimer = frame.flashTimer + elapsed

        local flashTime = frame.flashTimer
        local alpha

        flashTime = flashTime%(frame.fadeInTime + frame.fadeOutTime + (frame.flashInHoldTime or 0) + (frame.flashOutHoldTime or 0))

        if (flashTime < frame.fadeInTime) then
            alpha = flashTime/frame.fadeInTime
        elseif (flashTime < frame.fadeInTime + (frame.flashInHoldTime or 0)) then
            alpha = 1
        elseif (flashTime < frame.fadeInTime + (frame.flashInHoldTime or 0)+frame.fadeOutTime) then
            alpha = 1 - ((flashTime - frame.fadeInTime - (frame.flashInHoldTime or 0))/frame.fadeOutTime);
        else
            alpha = 0
        end

        frame:SetAlpha(alpha + (frame.minAlpha and frame.minAlpha or 0))

        index = index - 1
    end

    if (#flashObjects == 0) then
        self:SetScript('OnUpdate', nil)
    end
end

ns.IsFlashing = function(frame)
    for index, value in pairs(flashObjects) do
        if (value == frame) then
            return 1
        end
    end

    return nil
end

ns.StopFlash = function(frame)
    tDeleteItem(flashObjects, frame)
    frame.flashTimer = nil
    frame:SetAlpha(0)
end

ns.StartFlash = function(frame, fadeInTime, fadeOutTime, flashInHoldTime, flashOutHoldTime)
    if (frame) then
        local index = 1
        while flashObjects[index] do
            if (flashObjects[index] == frame) then
                return
            end

            index = index + 1
        end

        frame.flashTimer = 0 
        frame.fadeInTime = fadeInTime
        frame.fadeOutTime = fadeOutTime
        frame.flashInHoldTime = flashInHoldTime
        frame.flashOutHoldTime = flashOutHoldTime

        tinsert(flashObjects, frame)

        f:SetScript('OnUpdate', Flash_OnUpdate)
    end
end