local QBCore = exports['qb-core']:GetCoreObject()
local playerConnectTimes = {}
local playerLastData = {} 

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        playerConnectTimes = {}
        playerLastData = {}
    end
end)

AddEventHandler('playerJoining', function()
    local src = source
    playerConnectTimes[src] = os.time()
end)

RegisterNetEvent('dw-combatlog:updatePlayerData', function(coords, pedModel, pedAppearance)
    local src = source
    
    if not src then return end
    
    playerLastData[src] = {
        coords = coords,
        pedModel = pedModel,
        pedAppearance = pedAppearance,
        lastUpdate = os.time()
    }
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then 
        playerConnectTimes[src] = nil
        playerLastData[src] = nil
        return 
    end
    
    local savedData = playerLastData[src]
    
    if not savedData then
        print("^1[COMBAT LOG] No saved data for player " .. GetPlayerName(src) .. "^0")
        playerConnectTimes[src] = nil
        return
    end
    
    local coords = savedData.coords
    local pedModel = savedData.pedModel
    local pedAppearance = savedData.pedAppearance
    
    local playTime = 0
    if playerConnectTimes[src] then
        playTime = os.time() - playerConnectTimes[src]
        playerConnectTimes[src] = nil
    end
    
    local discordId = nil
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    
    local steamName = GetPlayerName(src)
    local charName = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    
    local data = {
        discord = discordId,
        steam = steamName,
        character = charName
    }
    
    print("^2[COMBAT LOG] Player disconnected: " .. charName .. " (Playtime: " .. playTime .. "s)^0")
    
    TriggerClientEvent('dw-combatlog:showDisconnect', -1, coords, data, playTime, pedModel, pedAppearance)
    
    playerLastData[src] = nil
end)

RegisterNetEvent('dw-combatlog:testFromClient', function(coords, pedModel, pedAppearance)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then 
        return 
    end
    
    local discordId = nil
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    
    local steamName = GetPlayerName(src)
    local charName = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    
    local data = {
        discord = discordId,
        steam = steamName,
        character = charName
    }
    
    print("^3[COMBAT LOG TEST] Testing for " .. charName .. "^0")
    
    TriggerClientEvent('dw-combatlog:showDisconnect', -1, coords, data, 3665, pedModel, pedAppearance)
end)
