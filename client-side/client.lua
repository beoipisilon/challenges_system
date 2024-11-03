local countdown = 5
local currentChallenge = false

function StartCountdown()
    Citizen.CreateThread(function()
        countdown = 5
        while countdown > 0 do
            Citizen.Wait(1000)
            countdown = countdown - 1
        end
    end)
end

function API.StartChallenge()   
    currentChallenge = true
    StartCountdown()

    Citizen.CreateThread(function()
        while countdown == 0 do 
            drawTxt(("Desafio começará em %d..."):format(countdown), 0.5, 0.5)
            Citizen.Wait(4)
        end
    end)
end

function API.FinishChallenge()
    currentChallenge = false
end

AddEventHandler("gameEventTriggered", function(eventName, args)
    if eventName == "CEventNetworkEntityDamage" and currentChallenge then
        local victim = args[1]
        if IsPedAPlayer(victim) and victim == PlayerPedId() and GetEntityHealth(victim) <= 101 then
            Remote._KillChallenge({attacker = GetPlayerServerId(NetworkGetPlayerIndexFromPed(args[2]))})
        end
    end
end)
