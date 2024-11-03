local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")

local Challenges = {
    cache = {}
}

--- @param userId number
--- @return boolean
function Challenges:Exists(userId)
    return self.cache[userId] ~= nil or self.cache[self:GetOtherId(userId)] ~= nil
end

--- @param userId number
--- @return number|nil
function Challenges:GetOtherId(userId)
    for k, v in pairs(self.cache) do
        if v.userId == userId then
            return v.otherId
        elseif v.otherId == userId then
            return v.userId
        end
    end
    return nil
end

--- @param userId number
--- @param otherId number
--- @return void
function Challenges:Create(userId, otherId)
    local userLastPosition = GetPlayerPosition(userId)
    local otherLastPosition = GetPlayerPosition(otherId)

    self.cache[parseInt(userId)] = {
        userId = parseInt(userId),
        lastPosition = userLastPosition,
        otherId = parseInt(otherId),
        otherLastPosition = otherLastPosition
    }
end

RegisterCommand('desafiar', function(source, args)
    local Passport = vRP.Passport(source)
    if not Passport then return end 

    local ChallengedId = tonumber(args[1])
    if not ChallengedId or ChallengedId <= 0 then 
        Notify(source, "negado", "Você precisa digitar um ID válido para desafiar.", 5000)
        return 
    end

    local ChallengedSrc = vRP.Source(ChallengedId)
    if not ChallengedSrc then 
        Notify(source, "negado", ("O jogador de ID <b>%s</b> está offline."):format(ChallengedId), 5000)
        return
    end 

    if Challenges:Exists(ChallengedId) then
        Notify(source, "negado", ("O jogador de ID <b>%s</b> já está em um desafio."):format(ChallengedId), 5000)
        return  
    end

    if vRP.request(ChallengedSrc, ("Você foi desafiado pelo ID <b>%s</b>, deseja aceitar o desafio?"):format(Passport)) then
        Challenges:Create(Passport, ChallengedId)
        Notify(source, "sucesso", ("O jogador de ID <b>%s</b> aceitou seu desafio e ele começará em 5 segundos."):format(ChallengedId), 5000)
        Notify(ChallengedSrc, "sucesso", ("Desafio aceito, ele começará em 5 segundos."), 5000)

        vRP.Teleport(ChallengedSrc, 5258.1,-5225.72,24.21)
        vRP.Teleport(source, 5246.18,-5241.73,22.29)
        Remote._StartChallenge(ChallengedSrc)
        Remote._StartChallenge(source)
    end
end)

--- @param data table
--- @return void
function API.KillChallenge(data)
    local attackerSrc = data.attacker
    local playerId = vRP.Passport(source)
    local winnerId, loserId

    if attackerSrc == 0 or attackerSrc == nil then
        winnerId = playerId
        loserId = Challenges:GetOtherId(playerId)
    else
        winnerId = attackerSrc
        loserId = playerId 
    end

    if loserId then
        Notify(vRP.Source(winnerId), "sucesso", "Você venceu o desafio!", 5000)
        Notify(vRP.Source(loserId), "negado", "Você perdeu o desafio!", 5000)

        local winnerLastPosition = Challenges.cache[winnerId] and Challenges.cache[winnerId].lastPosition
        local loserLastPosition = Challenges.cache[loserId] and Challenges.cache[loserId].otherLastPosition

        if winnerLastPosition then
            vRP.Teleport(vRP.Source(winnerId), winnerLastPosition.x, winnerLastPosition.y, winnerLastPosition.z)
        end
        if loserLastPosition then
            vRP.Teleport(vRP.Source(loserId), loserLastPosition.x, loserLastPosition.y, loserLastPosition.z)
        end

        Challenges.cache[winnerId] = nil
        Challenges.cache[loserId] = nil

        Remote._FinishChallenge(vRP.Source(loserId))
    else
        Notify(vRP.Source(playerId), "negado", "Desafio não encontrado.", 5000)
    end
end