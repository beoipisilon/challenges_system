--- @param userId number
--- @return vector3
function GetPlayerPosition(userId)
    local player = vRP.Source(userId)
    if player then
        return GetEntityCoords(GetPlayerPed(player))
    end
    return nil
end

--- @param source number
--- @param type string
--- @param message string
--- @param duration number
--- @return void
local function Notify(source, type, message, duration)
    TriggerClientEvent("Notify", source, type, message, duration)
end
