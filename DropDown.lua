local _, LibAddonGUI = ...
local lib = LibStub:GetLibrary("LibAddonGUI-1.0")
local utils = LibStub:GetLibrary("LibAddonUtils-1.0")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function LibAddonGUI:CreateDropDown(parent, flags)
    --[[ flags
        SetValue*: func, on select callback
            -args: dropdown, selected
            -do not call set text or set .selected
        name: str, frame name
        menu*: table, initialization menu
            key* = {
                text* = "string",
                default = true,
            }
        width: int, frame width
    ]]

    local dropdown = CreateFrame("Frame", flags.name, parent, "UIDropDownMenuTemplate")
    if not flags.ignoreSkin then
        tinsert(self.elements.DropDownBox, dropdown)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    function dropdown:SetSize(width)
        UIDropDownMenu_SetWidth(dropdown, width)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    function dropdown:SetText(text)
        UIDropDownMenu_SetText(dropdown, text)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    function dropdown:SetValue(selected)
        dropdown.selected = selected
        dropdown:SetText(flags.menu[selected].text)

        flags.SetValue(dropdown, selected)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- Initialize dropdown

    dropdown:SetSize(flags.width or 150)

    UIDropDownMenu_Initialize(dropdown, function(frame, level, menuList)
        for k, v in utils.pairs(flags.menu) do
            local info = UIDropDownMenu_CreateInfo()
            info.func = dropdown.SetValue

            info.text = v.text
            info.arg1 = k
            info.checked = dropdown.selected == k
            info.hasArrow = false
            UIDropDownMenu_AddButton(info)

            if v.default then
                dropdown.default = k
            end
        end

        -- dropdown:SetValue(dropdown.default)
    end)

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    return dropdown
end