local _, LibAddonGUI = ...

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function LibAddonGUI:CreateScrollFrame(parent, flags)
    --[[ flags
        name*: str, button name
        template: str/valid template, overrides scrollframe template
        customScrollChild: bool, overrides scrollchild creation
            - eg. for editbox scrollframe
    ]]

    local scrollFrame = CreateFrame("ScrollFrame", flags.name, parent, flags.template or "UIPanelScrollFrameTemplate")
    scrollFrame.children = {}

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- Setting scrollbar points

    scrollFrame.scrollUpButton = _G[scrollFrame:GetName() .. "ScrollBarScrollUpButton"]
    scrollFrame.scrollUpButton:ClearAllPoints()
    scrollFrame.scrollUpButton:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", -2, -2)

    scrollFrame.scrollDownButton = _G[scrollFrame:GetName() .. "ScrollBarScrollDownButton"]
    scrollFrame.scrollDownButton:ClearAllPoints()
    scrollFrame.scrollDownButton:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", -2, 2)

    scrollFrame.scrollBar = _G[scrollFrame:GetName() .. "ScrollBar"]
    scrollFrame.scrollBar:ClearAllPoints()
    scrollFrame.scrollBar:SetPoint("TOP", scrollFrame.scrollUpButton, "BOTTOM", 0, -2)
    scrollFrame.scrollBar:SetPoint("BOTTOM", scrollFrame.scrollDownButton, "TOP", 0, 2)

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- Enable mousewheel on scrollbar

    scrollFrame.scrollBar:EnableMouseWheel(true)
    scrollFrame.scrollBar:SetScript("OnMouseWheel", function(self, direction)
        ScrollFrameTemplate_OnMouseWheel(scrollFrame, direction)
    end)

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    if not flags.ignoreSkin then
        tinsert(self.elements.ScrollBar, scrollFrame.scrollBar)
    end

    if not flags.customScrollChild then
        scrollFrame.scrollChild = CreateFrame("Frame")
        scrollFrame:SetScrollChild(scrollFrame.scrollChild)
        scrollFrame:SetAllPoints(parent)

        scrollFrame.scrollChild:SetSize(1, 1)
        scrollFrame.scrollChild:SetAllPoints(scrollFrame)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    function scrollFrame:GetScrollWidth()
        return scrollFrame:GetWidth() - 55
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    function scrollFrame:Clear()
        for k, v in pairs(scrollFrame.children) do
            v:ClearAllPoints()
            v:Hide()
        end

        table.wipe(scrollFrame.children)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    return scrollFrame
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function LibAddonGUI:CreateScrollingButtonGrid(parent, flags)
    -- Creates button grids
    --[[ flags
        -- see CreateScrollFrame flags
        columns*: int, number of columns of buttons
        height: int, override button height
    ]]

    local scrollFrame = self:CreateScrollFrame(parent, flags)

    local addon = self
    function scrollFrame:AddButton(info)
        --[[ info
            text
            onClick
            tooltip
        ]]

        local i = #scrollFrame.children

        local icon = addon:CreateButton(scrollFrame.scrollChild, {
            onClick = function(...)
                info.onClick(...)
            end,
            tooltip = info.tooltip or function()
                GameTooltip:AddLine(info.text)
            end,
        })

        icon:SetSize((scrollFrame:GetScrollWidth() - 15) / flags.columns, flags.height or 30)
        icon:GetFontString():SetSize(icon:GetWidth() - 5, icon:GetWidth() - 5)
        icon:SetText(info.text)

        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

        if i == 0 then
            icon:SetPoint("TOPLEFT", 5, -5)
        elseif i >= flags.columns and math.fmod(i, flags.columns) == 0 then
            icon:SetPoint("TOPLEFT", scrollFrame.children[i - flags.columns + 1], "BOTTOMLEFT", 0, -5)
        else
            icon:SetPoint("LEFT", scrollFrame.children[i], "RIGHT", 5, 0)
        end

        scrollFrame.children[i + 1] = icon

        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

        return icon
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    return scrollFrame
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function LibAddonGUI:CreateScrollingIconGrid(parent, flags)
    -- Creates icon grids
    --[[ flags
        -- see CreateScrollFrame flags
        iconSize*: int, height/width of icon
    ]]

    local scrollFrame = self:CreateScrollFrame(parent, flags)

    local addon = self
    function scrollFrame:AddIcon(info)
        --[[ info
            text
            func
            tooltip
        ]]

        local i = #scrollFrame.children

        local icon = addon:CreateIcon(scrollFrame.scrollChild, {
            onClick = info.onClick,
            tooltip = info.tooltip or function()
                GameTooltip:AddLine(info.text)
            end,
        })

        icon:SetSize(flags.iconSize, flags.iconSize)
        icon:SetText(info.text or " ")
        icon:GetFontString():SetSize(icon:GetWidth() - 5, icon:GetWidth() - 5)
        icon:SetNormalTexture(info.iconTexture or 134400)

        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- Calculate the max number of columns and then set point

        local maxCols = math.floor((scrollFrame:GetScrollWidth() + 5) / (flags.iconSize + 5))
        if i == 0 then
            icon:SetPoint("TOPLEFT", 5, -5)
        elseif i >= maxCols and math.fmod(i, maxCols) == 0 then
            icon:SetPoint("TOPLEFT", scrollFrame.children[i - maxCols + 1], "BOTTOMLEFT", 0, -5)
        else
            icon:SetPoint("LEFT", scrollFrame.children[i], "RIGHT", 5, 0)
        end

        scrollFrame.children[i + 1] = icon

        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

        return icon
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    return scrollFrame
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function LibAddonGUI:CreateScrollingList(parent, flags)
    -- Creates lines of text only with optional icons
    --[[ flags
        -- see CreateScrollFrame flags
    ]]

    local scrollFrame = self:CreateScrollFrame(parent, flags)

    function scrollFrame:AddLine(text, iconTexture)
        local i = #scrollFrame.children

        local icon = CreateFrame("Button", nil, scrollFrame.scrollChild)
        icon:SetSize(20, 20)

        if i == 0 then
            icon:SetPoint("TOPLEFT", 5, -5)
        else
            icon:SetPoint("TOPLEFT", scrollFrame.children[i].label, "BOTTOMLEFT", scrollFrame.children[i].hasIcon and -25 or 0, -5)
        end

        if iconTexture then
            icon.hasIcon = true
            icon:SetNormalTexture(iconTexture)
        end

        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

        local line = scrollFrame.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        line:SetWidth(scrollFrame:GetScrollWidth())
        line:SetJustifyH("LEFT")
        line:SetJustifyV("TOP")
        line:SetText(text)
        line:SetPoint("TOPLEFT", icon, "TOPRIGHT", icon.hasIcon and 5 or -20, 0)

        icon.label = line

        scrollFrame.children[i + 1] = icon
    end

    return scrollFrame
end