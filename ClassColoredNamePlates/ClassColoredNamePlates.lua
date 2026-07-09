local defaults = {
    enemy = false,
    friendly = false,
}

local function GetConfig()
    if not ClassColoredNamePlatesDB then
        ClassColoredNamePlatesDB = {}
    end

    for key, value in pairs(defaults) do
        if ClassColoredNamePlatesDB[key] == nil then
            ClassColoredNamePlatesDB[key] = value
        end
    end

    return ClassColoredNamePlatesDB
end

local function UpdateHealthColor(frame)
    if not frame or not frame.unit then
        return
    end

    local unit = frame.unit
    local config = GetConfig()

    if not UnitIsPlayer(unit) then
        return
    end

    local isFriendly = UnitIsFriend("player", unit)
    if isFriendly and not config.friendly then
        return
    end
    if not isFriendly and not config.enemy then
        return
    end

    local _, class = UnitClass(unit)
    if not class then
        return
    end

    local color = RAID_CLASS_COLORS[class]
    if not color then
        return
    end

    if frame.healthBar then
        frame.healthBar:SetStatusBarColor(color.r, color.g, color.b)
    end
end

hooksecurefunc("CompactUnitFrame_UpdateHealthColor", UpdateHealthColor)

local function RegisterOptionsPanel(panel)
    if Settings and Settings.RegisterCanvasLayoutCategory then
        local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
        category.ID = panel.name
        Settings.RegisterAddOnCategory(category)
        panel.category = category
    elseif InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(panel)
    end
end

local function CreateOptionsPanel()
    local panel = CreateFrame("Frame", "ClassColoredNamePlatesOptionsPanel")
    panel.name = "Class Colored Nameplates"

    panel:SetScript("OnShow", function()
        local config = GetConfig()
        panel.enemyCheckbox:SetChecked(config.enemy)
        panel.friendlyCheckbox:SetChecked(config.friendly)
    end)

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Class Colored Nameplates")

    local description = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    description:SetText("Choose which player nameplates should use class-colored health bars.")

    local enemyCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    enemyCheckbox:SetPoint("TOPLEFT", description, "BOTTOMLEFT", -2, -16)
    enemyCheckbox.Text:SetText("Color Enemy Nameplates")
    enemyCheckbox:SetScript("OnClick", function(self)
        local config = GetConfig()
        config.enemy = self:GetChecked()
    end)
    panel.enemyCheckbox = enemyCheckbox

    local friendlyCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    friendlyCheckbox:SetPoint("TOPLEFT", enemyCheckbox, "BOTTOMLEFT", 0, -8)
    friendlyCheckbox.Text:SetText("Color Friendly Nameplates")
    friendlyCheckbox:SetScript("OnClick", function(self)
        local config = GetConfig()
        config.friendly = self:GetChecked()
    end)
    panel.friendlyCheckbox = friendlyCheckbox

    RegisterOptionsPanel(panel)
end

CreateOptionsPanel()

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        GetConfig()
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)

SLASH_CLASSCOLOREDNAMEPLATES1 = "/ccnp"
function SlashCmdList.CLASSCOLOREDNAMEPLATES(msg)
    if Settings and Settings.OpenToCategory then
        Settings.OpenToCategory("Class Colored Nameplates")
    elseif InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory("Class Colored Nameplates")
    else
        print("Class Colored Nameplates: options panel could not be opened.")
    end
end