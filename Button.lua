local _, LibAddonGUI = ...

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function LibAddonGUI:CreateButton(parent, flags)
    --[[ flags
        name: str, button name
        onClick*: func, onclick callback
        clicks: str/valid buttons, registers button for button clicks
        tooltip: func, enables tooltips and executes callback
            -add tooltip lines only; do not show or set owner for tooltip
        stripTemplate: bool, strips button template to make a basic button
        fontObject, pushedFontObject, disabledFontObject: obj, sets button font object
    ]]

    local button = CreateFrame("Button", flags.name, parent, not flags.stripTemplate and "UIMenuButtonStretchTemplate")
    button:RegisterForClicks(flags.clicks or "AnyUp")

    if not flags.ignoreSkin then
        tinsert(self.elements.Button, button)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    if flags.fontObject then
        button:SetNormalFontObject(flags.fontObject)
    end

    if flags.pushedFontObject then
        button:SetPushedFontObject(flags.pushedFontObject)
    end

    if flags.disabledFontObject then
        button:SetDisabledFontObject(flags.disabledFontObject)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    button:SetScript("OnClick", function(...)
        flags.onClick(...)
    end)

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    if flags.tooltip then
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            flags.tooltip()
            GameTooltip:Show()
        end)

        button:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    return button
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function LibAddonGUI:CreateCheckButton(parent, flags)
    --[[ flags
        name: str, frame name
        onShow: func, called when checkbox is shown (e.g. to set SetChecked to a DB value)
        onClick: func, called when checkbox is clicked
        label: str, checkbox label
    ]]

    local checkbox = CreateFrame("CheckButton", flags.name, parent, "OptionsBaseCheckButtonTemplate")

    if not flags.ignoreSkin then
        tinsert(self.elements.CheckBox, checkbox)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    if flags.onShow then
        checkbox:SetScript("OnShow", function(self)
            flags.onShow(self)
        end)
    end

    if flags.onClick then
        checkbox:SetScript("OnClick", function(self)
            flags.onClick(self)
        end)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    local label = checkbox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("LEFT", checkbox, "RIGHT", 5, 1)
    label:SetText(flags.label)

    return checkbox, label
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function LibAddonGUI:CreateIcon(parent, flags)
    --[[ flags
        -- see CreateButton flags
    ]]

    flags.stripTemplate = true
    flags.ignoreSkin = true

    local icon = self:CreateButton(parent, flags)
    icon:SetNormalFontObject(GameFontHighlight)
    icon:SetPushedTextOffset(0, 0)

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    return icon
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function LibAddonGUI:CreateKeybind(parent, flags)
    --[[ flags
        -- see CreateButton flags
    ]]

    local keybind = self:CreateButton(parent, flags)

    keybind:SetScript("OnClick", function(self, button)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        if self.isRecording then
            self.isRecording = false
            self:EnableKeyboard(false)

            if button ~= "LeftButton" and button ~= "RightButton" then
                local bind = (IsShiftKeyDown() and "SHIFT-" .. button) or button
                bind = (IsControlKeyDown() and "CTRL-" .. bind) or bind
                bind = (IsAltKeyDown() and "ALT-" .. bind) or bind

                self:SetText(bind)
            end
        else
            self:SetText(flags.statusText)
            self:EnableKeyboard(true)
            local mods = {}
            self:SetScript("OnKeyDown", function(self, key, ...)
                if strfind(key, "ALT") then
                    mods["A"] = true
                elseif strfind(key, "CTRL") then
                    mods["C"] = true
                elseif strfind(key, "SHIFT") then
                    mods["S"] = true
                else
                    local bind = (mods["S"] and "SHIFT-" .. key) or key
                    bind = (mods["C"] and "CTRL-" .. bind) or bind
                    bind = (mods["A"] and "ALT-" .. bind) or bind

                    table.wipe(mods)

                    self:SetText(bind)
                    self:EnableKeyboard(false)
                    self.isRecording = false
                end
            end)

            self.isRecording = true
        end
    end)

    return keybind
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- function LibAddonGUI:CreateSecureActionButton(parent, flags)

-- end