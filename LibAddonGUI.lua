local _, LibAddonGUI = ...
local lib = LibStub:NewLibrary("LibAddonGUI-1.0", 1)
if not lib then return end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local addons = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function lib:GetAddon(addonName)
    return addons[addonName]
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function lib:RegisterAddon(addonName)
    local addon = {
        elements = {
            Frame = {},
            Button = {},
            CheckBox = {},
            ScrollBar = {},
            CloseButton = {},
            EditBox = {},
            DropDownBox = {},
        },
        name = addonName,
    }

    for k, v in pairs(LibAddonGUI) do
        addon[k] = v
    end

    addons[addonName] = addon

    return addon
end