---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by WGPavell.
--- DateTime: 26.03.2025 19:01
---

local function has_value (tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end