local function UpdateHealthColor(frame)
    -- Only for frames
    if not frame or not frame.unit then
        return
    end
    local unit = frame.unit
    -- Only for enemy players
    if not UnitIsPlayer(unit) then
        return
    end
    if UnitIsFriend("player", unit) then
        return
    end
    -- Fetch class
    local _, class = UnitClass(unit)
    if not class then
        return
    end
    -- Fetch class color
    local color = RAID_CLASS_COLORS[class]
    if not color then
        return
    end
    -- Update frame status bar color
    frame.healthBar:SetStatusBarColor(color.r, color.g, color.b)
end
hooksecurefunc("CompactUnitFrame_UpdateHealthColor", UpdateHealthColor)