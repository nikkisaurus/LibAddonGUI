local _, LibAddonGUI = ...

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function LibAddonGUI:RegisterAddOnSkin()
    if not _G["AddOnSkins"] then return end
    local AS = unpack(_G["AddOnSkins"])
    if not AS:CheckAddOn(self.name) then return end

    AS[self.name] = function()
        for element, elements in pairs(self.elements) do
            local skin = AS["Skin" .. element]
            for k, v in pairs(elements) do
                skin(AS, v)
            end
        end
    end

    AS:RegisterSkin(self.name, AS[self.name])

    AS[self.name]()
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function LibAddonGUI:ReSkinAddOn()
    if not _G["AddOnSkins"] then return end
    local AS = unpack(_G["AddOnSkins"])
    if not AS:CheckAddOn(self.name) or not AS[self.name] then return end
    AS[self.name]()
end