--Initialization Steps
LanScroll = {}
LanScroll.empty_strings = {}
LanScroll.empty_tables = {}
LanScroll.anim_strings = {}
LanScroll.scroll_area_frames = {}

-- Scroll Area Creation Function
function LanScroll:CreateScrollArea(id, height, x_pos, y_pos, textalign, direction, font_face, font_size, font_flags, font_face_sticky, font_size_sticky, font_flags_sticky, animation_duration, animation_duration_sticky)
    LanScroll.scroll_area_frames[id] = CreateFrame("Frame", nil, UIParent)
    LanScroll.scroll_area_frames[id.."sticky"] = CreateFrame("Frame", nil, UIParent)
    -- Enable these two lines to see the scroll area on the screen for more accurate placement, etc
    -- LanScroll.scroll_area_frames[id]:SetBackdrop({ bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeFile = nil, edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0} })
    -- LanScroll.scroll_area_frames[id]:SetBackdropColor(0, 0, 0, 1)

    -- Set frame width
    LanScroll.scroll_area_frames[id]:SetWidth(1)
    LanScroll.scroll_area_frames[id.."sticky"]:SetWidth(1)

    -- Set frame height
    LanScroll.scroll_area_frames[id]:SetHeight(height)
    LanScroll.scroll_area_frames[id.."sticky"]:SetHeight(height)

    -- Position frame
    LanScroll.scroll_area_frames[id]:SetPoint("BOTTOM", UIParent, "BOTTOM", x_pos, y_pos)
    LanScroll.scroll_area_frames[id.."sticky"]:SetPoint("BOTTOM", UIParent, "BOTTOM", x_pos, y_pos)

    -- Text alignment
    LanScroll.scroll_area_frames[id].textalign = textalign
    LanScroll.scroll_area_frames[id.."sticky"].textalign = textalign

    -- Scroll direction
    LanScroll.scroll_area_frames[id].direction = direction or "up"
    LanScroll.scroll_area_frames[id.."sticky"].direction = direction or "up"

    -- Font face
    LanScroll.scroll_area_frames[id].font_face = font_face or LanScroll.font_face
    LanScroll.scroll_area_frames[id.."sticky"].font_face = font_face_sticky or LanScroll.font_face_sticky

    -- Font size
    LanScroll.scroll_area_frames[id].font_size = font_size or LanScroll.font_size
    LanScroll.scroll_area_frames[id.."sticky"].font_size = font_size_sticky or LanScroll.font_size_sticky

    -- Font flags
    LanScroll.scroll_area_frames[id].font_flags = font_flags or LanScroll.font_flags
    LanScroll.scroll_area_frames[id.."sticky"].font_flags = font_flags_sticky or LanScroll.font_flags_sticky

    -- Create anim_string table
    LanScroll.anim_strings[id] = {}
    LanScroll.anim_strings[id.."sticky"] = {}

    -- Set movement speed
    LanScroll.scroll_area_frames[id].movement_speed = (animation_duration or LanScroll.animation_duration) / height
    LanScroll.scroll_area_frames[id.."sticky"].movement_speed = (animation_duration_sticky or LanScroll.animation_duration_sticky) / height

    -- Set animation duration
    LanScroll.scroll_area_frames[id].animation_duration = animation_duration or LanScroll.animation_duration
    LanScroll.scroll_area_frames[id.."sticky"].animation_duration = animation_duration_sticky or LanScroll.animation_duration_sticky
end


-- Font Settings
LanScroll.font_face                       = LanConfig.Media.Font
LanScroll.font_face_sticky                = LanConfig.Media.Font
LanScroll.font_flags                      = "OUTLINE"    -- Some text can be hard to read without it.
LanScroll.font_flags_sticky               = "OUTLINE"
LanScroll.font_size                       = 11
LanScroll.font_size_sticky                = 15

-- Animation Settings
LanScroll.blink_speed                     = 0.5
LanScroll.fade_in_time                    = 0.2         -- Percentage of the animation start spent fading in.
LanScroll.fade_out_time                   = 0.8         -- At what percentage should we begin fading out.
LanScroll.animation_duration              = 5           -- Time it takes for an animation to complete. (in seconds)
LanScroll.animation_duration_sticky       = 2.5         -- Time it takes for a sticky animation to complete. (in seconds)
LanScroll.animations_per_scrollframe      = 15          -- Maximum number of displayed animations in each scrollframe.
LanScroll.animation_vertical_spacing      = 10          -- Minimum spacing between animations.
LanScroll.animation_speed                 = 1           -- Modifies animation_duration.  1 = 100%
LanScroll.animation_delay                 = 0.015       -- Frequency of animation updates. (in seconds)

-- Make your scroll areas
-- Format: LanScroll:CreateScrollArea(identifier, height, x_pos, y_pos, textalign, direction[, font_face][, font_size][, font_flags][, font_face_sticky][, font_size_sticky][, font_flags_sticky][, animation_duration][, animation_duration_sticky])
-- Frames are relative to BOTTOM UIParent BOTTOM
--
-- Then you can pipe input into each scroll area using:
-- LanScroll:AddText(text_to_show, sticky_style, scroll_area_identifer)

LanScroll:CreateScrollArea("Error", 75, 0, 750, "CENTER", "up", nil, nil, nil, nil, nil, nil, 2.5, 2.5)
LanScroll:CreateScrollArea("Notification", 110, 0, 585, "CENTER", "down", nil, nil, nil, nil, nil, nil, 3.5, 3.5)
LanScroll:CreateScrollArea("Information", 100, 0, 160, "CENTER", "down", nil, nil, nil, nil, nil, nil, 2.5, 1.25)
LanScroll:CreateScrollArea("Outgoing", 150, 162.5, 385, "LEFT", "up")
LanScroll:CreateScrollArea("Incoming", 150, -162.5, 385, "RIGHT", "down")

local last_use = 0

local function CollisionCheck(newtext)
    local destination_scroll_area = LanScroll.anim_strings[newtext.scrollarea]
    local current_animations = #destination_scroll_area
    if current_animations > 0 then -- Only if there are already animations running

        -- Scale the per pixel time based on the animation speed.
        local perPixelTime = LanScroll.scroll_area_frames[newtext.scrollarea].movement_speed / newtext.animationSpeed
        local curtext = newtext -- start with our new string
        local previoustext, previoustime

        -- cycle backwards through the table of fontstrings since our newest ones have the highest index
        for x = current_animations, 1, -1 do
            previoustext = destination_scroll_area[x]

            if not newtext.sticky then
                -- Calculate the elapsed time for the top point of the previous display event.
                -- TODO: Does this need to be changed since we anchor LEFT and not TOPLEFT?
                previoustime = previoustext.totaltime - (previoustext.fontSize + LanScroll.animation_vertical_spacing) * perPixelTime

                --[[If there is a collision, then we set the older fontstring to a higher animation time
                Which 'pushes' it upward to make room for the new one--]]
                if (previoustime <= curtext.totaltime) then
                    previoustext.totaltime = curtext.totaltime + (previoustext.fontSize + LanScroll.animation_vertical_spacing) * perPixelTime
                else
                    return -- If there was no collision, then we can safely stop checking for more of them
                end
            else
                previoustext.curpos = previoustext.curpos + (previoustext.fontSize + LanScroll.animation_vertical_spacing)
            end

            -- Check the next one against the current one
            curtext = previoustext
        end
    end
end

local blink_id = 0
local make_blink_group = function(self) 
    blink_id = blink_id + 1
    self.anim = self:CreateAnimationGroup("Blink"..blink_id) 
    self.anim.fadein = self.anim:CreateAnimation("ALPHA", "FadeIn") 
    self.anim.fadein:SetChange(1) 
    self.anim.fadein:SetOrder(2) 

    self.anim.fadeout = self.anim:CreateAnimation("ALPHA", "FadeOut") 
    self.anim.fadeout:SetChange(-1) 
    self.anim.fadeout:SetOrder(1) 
end 

local start_blinking = function(self, duration) 
    if not self.anim then 
        make_blink_group(self) 
    end 

    self.anim.fadein:SetDuration(duration) 
    self.anim.fadeout:SetDuration(duration) 
    self.anim:Play() 
end 

local stop_blinking = function(self) 
    if self.anim then 
        self.anim:Finish() 
    end 
end 

local function Move(self, elapsed)
    local t
    -- Loop through all active fontstrings
    for k,v in pairs(LanScroll.anim_strings) do

        for l,u in pairs(LanScroll.anim_strings[k]) do
            t = LanScroll.anim_strings[k][l]

            if t and t.inuse then
                --increment it's timer until the animation delay is fulfilled
                t.timer = (t.timer or 0) + elapsed
                if t.timer >= LanScroll.animation_delay then

                    --[[we store it's elapsed time separately so we can continue to delay
                    its animation (so we're not updating every onupdate, but can still
                    tell what its full animation duration is)--]]
                    t.totaltime = t.totaltime + t.timer

                    --[[If the animation is not complete, then we need to animate it by moving
                    its Y coord (in our sample scrollarea) the proper amount.  If it is complete,
                    then we hide it and flag it for recycling --]]
                    local percentDone = t.totaltime / LanScroll.scroll_area_frames[t.scrollarea].animation_duration
                    if (percentDone <= 1) then
                        t.text:ClearAllPoints()
                        local area_height = LanScroll.scroll_area_frames[t.scrollarea]:GetHeight()
                        if not t.sticky then
                            -- Scroll the text
                            if LanScroll.scroll_area_frames[t.scrollarea].direction == "up" then
                                t.curpos = area_height * percentDone -- move up
                            else
                                t.curpos = area_height - (area_height * percentDone)
                            end
                            t.text:SetPoint(LanScroll.scroll_area_frames[t.scrollarea].textalign, LanScroll.scroll_area_frames[t.scrollarea], "BOTTOMLEFT", 0, t.curpos)
                        else
                            -- Static text
                            if t.curpos > area_height/2 then t.totaltime = 99 end
                            t.text:SetPoint(LanScroll.scroll_area_frames[t.scrollarea].textalign, LanScroll.scroll_area_frames[t.scrollarea], LanScroll.scroll_area_frames[t.scrollarea].textalign, 0, t.curpos)
                        end

                        -- Blink text
                        if t.sticky and t.blink then
                            if not t.blinking then
                                t.text:SetAlpha(1)
                                t.blinking = true
                            end
                            start_blinking(t.text, LanScroll.blink_speed)
                        elseif (percentDone <= LanScroll.fade_in_time) then
                            -- Fade in
                            --if (percentDone <= LanScroll.fade_in_time) then
                            t.text:SetAlpha(1 * (percentDone / LanScroll.fade_in_time))
                            -- Fade out
                        elseif (percentDone >= LanScroll.fade_out_time) then
                            t.text:SetAlpha(1 * (1 - percentDone) / (1 - LanScroll.fade_out_time))
                            -- Full vis for times inbetween
                        else
                            t.text:SetAlpha(1)
                        end
                    else
                        -- /script LanScroll:AddText("Kill Shot", true, "Notification", true)
                        if t.blink then
                            stop_blinking(t.text)
                            t.blink  = false
                            t.blinking = false
                        end
                        t.text:Hide()
                        t.inuse = false
                    end

                    t.timer = 0        --reset our animation delay timer
                end
            end

            --[[Now, we loop backwards through the fontstrings to determine which ones
            can be recycled --]]
            for j = #LanScroll.anim_strings[k], 1, -1 do
                t = LanScroll.anim_strings[k][j]
                if not t.inuse then
                    table.remove(LanScroll.anim_strings[k], j)
                    -- Place the used frame into our recycled cache
                    LanScroll.empty_strings[(#LanScroll.empty_strings or 0) + 1] = t.text
                    for key in next, t do t[key] = nil end
                    LanScroll.empty_tables[(#LanScroll.empty_tables or 0)+1] = t
                end
            end
        end
    end
end

function LanScroll:AddText(text, sticky, scrollarea, blink)
    if not text or not scrollarea then return end
    local destination_area
    if not sticky then
        destination_area = LanScroll.anim_strings[scrollarea]
    else
        destination_area = LanScroll.anim_strings[scrollarea.."sticky"]
    end
    if not destination_area then return end
    local t
    -- If there are too many frames in the animation area, steal one of them first
    if (destination_area and (#destination_area or 0) >= LanScroll.animations_per_scrollframe) then
        t = table.remove(destination_area, 1)

        -- If there are frames in the recycle bin, then snatch one of them!
    elseif (#LanScroll.empty_tables or 0) > 0 then
        t = table.remove(LanScroll.empty_tables, 1)

        -- If we still don't have a frame, then we'll just have to create a brand new one
    else
        t = {}
    end
    if not t.text then
        t.text = table.remove(LanScroll.empty_strings, 1) or LanScroll.event_frame:CreateFontString(nil, "BORDER")
    end

    -- Settings which need to be set/reset on each fontstring after it is created/obtained
    if sticky then
        t.fontSize = LanScroll.scroll_area_frames[scrollarea.."sticky"].font_size
    else
        t.fontSize = LanScroll.scroll_area_frames[scrollarea].font_size
    end
    t.sticky = sticky
    if blink then
        t.blink = true
        t.blinking = false
    else
        t.blink = false
        t.blinking = false
    end
    t.text:SetFont(sticky and LanScroll.scroll_area_frames[scrollarea.."sticky"].font_face or LanScroll.scroll_area_frames[scrollarea].font_face, t.fontSize, sticky and LanScroll.scroll_area_frames[scrollarea.."sticky"].font_flags or LanScroll.scroll_area_frames[scrollarea].font_flags)
    t.text:SetText(text)
    t.direction = destination_area.direction
    t.inuse = true
    t.timer = 0
    t.totaltime = 0
    t.curpos = 0
    t.text:ClearAllPoints()
    if t.sticky then
        t.text:SetPoint(LanScroll.scroll_area_frames[scrollarea.."sticky"].textalign, LanScroll.scroll_area_frames[scrollarea.."sticky"], LanScroll.scroll_area_frames[scrollarea.."sticky"].textalign, 0, 0)
        t.text:SetDrawLayer("OVERLAY") -- on top of normal texts.
    else
        t.text:SetPoint(LanScroll.scroll_area_frames[scrollarea].textalign, LanScroll.scroll_area_frames[scrollarea], "BOTTOMLEFT", 0, 0)
        t.text:SetDrawLayer("ARTWORK")
    end
    t.text:SetAlpha(0)
    t.text:Show()
    t.animationSpeed = LanScroll.animation_speed
    t.scrollarea = t.sticky and scrollarea.."sticky" or scrollarea

    -- Make sure that adding this fontstring will not collide with anything!
    CollisionCheck(t)

    -- Add the fontstring into our table which gets looped through during the OnUpdate
    destination_area[#destination_area+1] = t
    last_use = 0
end

local function OnUpdate(s,e)
    Move(s, e)
    -- Keep footprint down by releasing stored tables and strings after we've been idle for a bit.
    last_use = last_use + e
    if last_use > 30 then
        if #LanScroll.empty_tables and #LanScroll.empty_tables > 0 then
            LanScroll.empty_tables = {}
        end
        if #LanScroll.empty_strings and #LanScroll.empty_strings > 0 then
            LanScroll.empty_strings = {}
        end
        last_use = 0
    end
end
LanScroll.event_frame = CreateFrame("Frame")
LanScroll.event_frame:SetScript("OnUpdate", OnUpdate)