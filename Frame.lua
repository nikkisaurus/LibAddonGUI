local _, LibAddonGUI = ...

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function LibAddonGUI:CreateFrame(parent, flags)
    --[[ flags
        name: str, frame name
        draggable: bool, enable frame dragging
        title: str, enables title frame and sets title
        template: str/valid template name, adds template to frame
        stripTemplate: bool, strips default template to create a basic frame; overrides template

    ]]

    local flags = flags or {}

    local frame = CreateFrame("Frame", flags.name, parent, not flags.stripTemplate and (flags.template or "UIPanelDialogTemplate"))
    frame:Hide()

    tinsert(UISpecialFrames, frame:GetName())
    if not flags.ignoreSkin then
        tinsert(self.elements.Frame, frame)
        tinsert(self.elements.CloseButton, _G[frame:GetName() .. "Close"])
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    if flags.draggable then
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", frame.StartMoving)
        frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    if flags.title then
        frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        frame.title:SetText(flags.title)
        frame.title:SetPoint("TOP", 0, -5)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    return frame
end