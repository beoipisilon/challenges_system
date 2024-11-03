--- @param text string
--- @param x number
--- @param y number
--- @return void
function drawTxt(text, x, y)
    local res_x, res_y = GetActiveScreenResolution()

    SetTextFont(4)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
    SetTextCentre(1)

    SetTextEntry("STRING")
    AddTextComponentString(text)

    local adjustedX = x - (0.5 * 0.15)  
    local adjustedY = y

    if res_x >= 2000 then
        DrawText(adjustedX + 0.076, adjustedY)
    else
        DrawText(adjustedX, adjustedY)
    end
end
