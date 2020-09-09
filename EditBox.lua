local _, LibAddonGUI = ...
local utils = LibStub:GetLibrary("LibAddonUtils-1.0")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function LibAddonGUI:CreateEditBox(parent, flags)
    --[[ flags
        name*: str, frame name
        width*: int, frame width
        height*: int, frame height
        multiLine: bool, set editbox multiline
        tabSpaces: bool, enable tab to space conversion
        autoFocus: bool, enables autoFocus
        fontObject = obj, sets editbox font object
        insets = tbl, sets editbox text insets
        charCount = bool, enables charCount
        autoHighlight = bool, enables autoHighlight
    ]]

    local ignoreSkin = flags.ignoreSkin
    flags.ignoreSkin = true
    flags.template = "InputScrollFrameTemplate"
    flags.customScrollChild = true

    local editboxScrollFrame = self:CreateScrollFrame(parent, flags)
    editboxScrollFrame:SetSize(flags.width, flags.height)

    if not ignoreSkin then
        tinsert(self.elements.ScrollBar, editboxScrollFrame.scrollBar)
        tinsert(self.elements.EditBox, editboxScrollFrame)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- Set up editbox properties

    local editbox = editboxScrollFrame.EditBox
    editbox:SetAllPoints(true)
    if not flags.charCount then
        editboxScrollFrame.CharCount:Hide()
    end
    editbox:SetMultiLine(flags.multiLine)
    editbox:SetAutoFocus(flags.autoFocus)
    editbox:SetFontObject(flags.fontObject or "ChatFontNormal")
    editbox:SetWidth(editboxScrollFrame:GetWidth())
    editbox:SetTextInsets(utils.unpack(flags.insets, {10, 10, 10, 10}))

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- Set up editbox scripts

    local function ClearFocus()
        editbox:HighlightText(0, 0)
        editbox:ClearFocus()
    end

    if flags.autoHighlight then
        editbox:SetScript("OnEditFocusGained", function(self)
            self:HighlightText()
        end)
    end

    editbox:SetScript("OnEditFocusLost", ClearFocus)

    editbox:SetScript("OnEscapePressed", ClearFocus)

    if flags.tabSpaces then
        editbox:SetScript("OnTabPressed", function(self)
            self:Insert("    ")
        end)
    end

    if flags.onTextChanged then
        editbox:SetScript("OnTextChanged", function(...)
            flags.onTextChanged(...)
        end)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    return editboxScrollFrame
end