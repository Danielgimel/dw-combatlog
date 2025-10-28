local QBCore = exports['qb-core']:GetCoreObject()
local activeMarkers = {}
local clonedPeds = {}

CreateThread(function()
    while true do
        Wait(5000) 
        
        local playerPed = PlayerPedId()
        if DoesEntityExist(playerPed) then
            local coords = GetEntityCoords(playerPed)
            local pedModel = GetEntityModel(playerPed)
            
            local pedAppearance = {
                components = {},
                props = {},
                headBlend = {},
                hair = {}
            }
            
            for i = 0, 11 do
                pedAppearance.components[i] = {
                    drawable = GetPedDrawableVariation(playerPed, i),
                    texture = GetPedTextureVariation(playerPed, i)
                }
            end
            
            for i = 0, 7 do
                pedAppearance.props[i] = {
                    drawable = GetPedPropIndex(playerPed, i),
                    texture = GetPedPropTextureIndex(playerPed, i)
                }
            end
            
            local success, shapeFirst, shapeSecond, shapeThird, skinFirst, skinSecond, skinThird, shapeMix, skinMix, thirdMix = pcall(GetPedHeadBlendData, playerPed)
            if success then
                pedAppearance.headBlend = {
                    shapeFirst = shapeFirst,
                    shapeSecond = shapeSecond,
                    shapeThird = shapeThird,
                    skinFirst = skinFirst,
                    skinSecond = skinSecond,
                    skinThird = skinThird,
                    shapeMix = shapeMix,
                    skinMix = skinMix,
                    thirdMix = thirdMix
                }
            end
            
            pedAppearance.hair = {
                color = GetPedHairColor(playerPed),
                highlight = GetPedHairHighlightColor(playerPed)
            }
            
            pedAppearance.eyeColor = GetPedEyeColor(playerPed)
            
            TriggerServerEvent('dw-combatlog:updatePlayerData', coords, pedModel, pedAppearance)
        end
    end
end)

RegisterCommand('testcombatlog', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local pedModel = GetEntityModel(playerPed)
    
    local pedAppearance = {
        components = {},
        props = {},
        headBlend = {},
        hair = {}
    }
    
    for i = 0, 11 do
        pedAppearance.components[i] = {
            drawable = GetPedDrawableVariation(playerPed, i),
            texture = GetPedTextureVariation(playerPed, i)
        }
    end
    
    for i = 0, 7 do
        pedAppearance.props[i] = {
            drawable = GetPedPropIndex(playerPed, i),
            texture = GetPedPropTextureIndex(playerPed, i)
        }
    end
    
    local success, shapeFirst, shapeSecond, shapeThird, skinFirst, skinSecond, skinThird, shapeMix, skinMix, thirdMix = pcall(GetPedHeadBlendData, playerPed)
    if success then
        pedAppearance.headBlend = {
            shapeFirst = shapeFirst,
            shapeSecond = shapeSecond,
            shapeThird = shapeThird,
            skinFirst = skinFirst,
            skinSecond = skinSecond,
            skinThird = skinThird,
            shapeMix = shapeMix,
            skinMix = skinMix,
            thirdMix = thirdMix
        }
    end
    
    pedAppearance.hair = {
        color = GetPedHairColor(playerPed),
        highlight = GetPedHairHighlightColor(playerPed)
    }
    
    pedAppearance.eyeColor = GetPedEyeColor(playerPed)
    
    TriggerServerEvent('dw-combatlog:testFromClient', coords, pedModel, pedAppearance)
    
    QBCore.Functions.Notify('Combat Log Test Started!', 'success')
end, false)

RegisterNetEvent('dw-combatlog:showDisconnect')
AddEventHandler('dw-combatlog:showDisconnect', function(coords, data, playTime, pedModel, pedAppearance)
    if not coords or not data or not pedModel then
        print("^1[COMBAT LOG] Invalid data received^0")
        return
    end
    
    local markerId = #activeMarkers + 1
    
    print("^2[COMBAT LOG] Creating marker for: " .. data.character .. " at " .. tostring(coords) .. "^0")
    
    CreatePedClone(coords, data, playTime, pedModel, pedAppearance, markerId)
    
    activeMarkers[markerId] = {
        coords = coords,
        data = data,
        playTime = playTime,
        endTime = GetGameTimer() + 10000, 
        showUI = false,
        ascending = false
    }
end)

function CreatePedClone(coords, data, playTime, pedModel, pedAppearance, markerId)
    CreateThread(function()
        RequestModel(pedModel)
        local timeout = 0
        while not HasModelLoaded(pedModel) and timeout < 50 do
            Wait(100)
            timeout = timeout + 1
        end
        
        if not HasModelLoaded(pedModel) then
            print("^1[COMBAT LOG] Failed to load model " .. pedModel .. "^0")
            return
        end
        
        local ped = CreatePed(4, pedModel, coords.x, coords.y, coords.z - 0.98, 0.0, false, true)
        
        if not DoesEntityExist(ped) then
            print("^1[COMBAT LOG] Failed to create ped^0")
            return
        end
        
        SetEntityAsMissionEntity(ped, true, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedCanRagdoll(ped, true)
        
        if pedAppearance then
            if pedAppearance.headBlend and pedAppearance.headBlend.shapeFirst then
                SetPedHeadBlendData(ped, 
                    pedAppearance.headBlend.shapeFirst or 0, 
                    pedAppearance.headBlend.shapeSecond or 0, 
                    pedAppearance.headBlend.shapeThird or 0, 
                    pedAppearance.headBlend.skinFirst or 0, 
                    pedAppearance.headBlend.skinSecond or 0, 
                    pedAppearance.headBlend.skinThird or 0, 
                    pedAppearance.headBlend.shapeMix or 0.0, 
                    pedAppearance.headBlend.skinMix or 0.0, 
                    pedAppearance.headBlend.thirdMix or 0.0, 
                    false
                )
            end
            
            if pedAppearance.components then
                for i = 0, 11 do
                    if pedAppearance.components[i] then
                        SetPedComponentVariation(ped, i, pedAppearance.components[i].drawable, pedAppearance.components[i].texture, 0)
                    end
                end
            end
            
            if pedAppearance.props then
                for i = 0, 7 do
                    if pedAppearance.props[i] and pedAppearance.props[i].drawable ~= -1 then
                        SetPedPropIndex(ped, i, pedAppearance.props[i].drawable, pedAppearance.props[i].texture, true)
                    end
                end
            end
            
            if pedAppearance.hair then
                SetPedHairColor(ped, pedAppearance.hair.color or 0, pedAppearance.hair.highlight or 0)
            end
        
            if pedAppearance.eyeColor then
                SetPedEyeColor(ped, pedAppearance.eyeColor)
            end
        end
        
        Wait(100)
        
        SetPedToRagdoll(ped, 10000, 10000, 0, true, true, false)
        SetEntityHealth(ped, 0)
        
        exports['qb-target']:AddTargetEntity(ped, {
            options = {
                {
                    icon = 'fas fa-info-circle',
                    label = 'View Info',
                    action = function()
                        if activeMarkers[markerId] then
                            activeMarkers[markerId].showUI = true
                            if not activeMarkers[markerId].ascending then
                                activeMarkers[markerId].ascending = true
                                StartAscension(ped, coords, markerId)
                            end
                        end
                    end
                }
            },
            distance = 2.5
        })
        
        clonedPeds[markerId] = ped
        
        print("^2[COMBAT LOG] Ped created successfully for " .. data.character .. "^0")
    end)
end

function StartAscension(ped, originalCoords, markerId)
    CreateThread(function()
        if not DoesEntityExist(ped) then return end
        
        SetPedToRagdoll(ped, 0, 0, 0, false, false, false)
        Wait(500)
        
        ClearPedTasksImmediately(ped)
        FreezeEntityPosition(ped, true)
        SetEntityCollision(ped, false, false)
        SetEntityInvincible(ped, true)
        
        local currentCoords = GetEntityCoords(ped)
        local startX = currentCoords.x
        local startY = currentCoords.y
        local startZ = currentCoords.z
        local yawRotation = GetEntityHeading(ped)
        
        local ptfxHandle = nil
        RequestNamedPtfxAsset("core")
        local ptfxTimeout = 0
        while not HasNamedPtfxAssetLoaded("core") and ptfxTimeout < 50 do
            Wait(100)
            ptfxTimeout = ptfxTimeout + 1
        end
        
        if HasNamedPtfxAssetLoaded("core") then
            UseParticleFxAssetNextCall("core")
            ptfxHandle = StartParticleFxLoopedOnEntity("ent_dst_elec_fire_sp", ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, false, false, false)
        end
        
        local standingDuration = 5000
        local standingStartTime = GetGameTimer()
        
        while GetGameTimer() - standingStartTime < standingDuration do
            Wait(50)
            if not DoesEntityExist(ped) then return end
            
            local elapsed = GetGameTimer() - standingStartTime
            local progress = elapsed / standingDuration
            
            local liftZ = startZ + (1.0 * progress)
            
            SetEntityCoordsNoOffset(ped, startX, startY, liftZ, false, false, false)
            SetEntityRotation(ped, 0.0, 0.0, yawRotation, 2, true)
            
            if activeMarkers[markerId] then
                activeMarkers[markerId].coords = vector3(startX, startY, liftZ)
            end
        end
        
        startZ = startZ + 1.0
        
        local targetZ = startZ + 40.0
        local ascentDuration = 25000
        local ascentStartTime = GetGameTimer()
        
        while GetGameTimer() - ascentStartTime < ascentDuration do
            Wait(50)
            
            if not DoesEntityExist(ped) then break end
            
            local elapsed = GetGameTimer() - ascentStartTime
            local progress = elapsed / ascentDuration
            
            yawRotation = yawRotation + 2.0
            
            local heightProgress = progress * progress
            local currentZ = startZ + (targetZ - startZ) * heightProgress
            
            local wobbleX = math.sin(elapsed / 800) * 0.2
            local wobbleY = math.cos(elapsed / 800) * 0.2
            
            local spiralRadius = 0.3 * progress
            local spiralX = startX + math.sin(elapsed / 500) * spiralRadius + wobbleX
            local spiralY = startY + math.cos(elapsed / 500) * spiralRadius + wobbleY
            
            SetEntityCoordsNoOffset(ped, spiralX, spiralY, currentZ, false, false, false)
            SetEntityRotation(ped, 0.0, 0.0, yawRotation, 2, true)
            
            if progress > 0.7 then
                local fadeProgress = (progress - 0.7) / 0.3
                SetEntityAlpha(ped, math.floor(255 * (1 - fadeProgress)), false)
            end
            
            if activeMarkers[markerId] then
                activeMarkers[markerId].coords = vector3(spiralX, spiralY, currentZ)
            end
        end
        
        if ptfxHandle then
            StopParticleFxLooped(ptfxHandle, 0)
        end
        
        if DoesEntityExist(ped) then
            exports['qb-target']:RemoveTargetEntity(ped)
            DeleteEntity(ped)
        end
        
        clonedPeds[markerId] = nil
        activeMarkers[markerId] = nil
    end)
end

CreateThread(function()
    while true do
        Wait(100) 
        
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local currentTime = GetGameTimer()
        
        local hasActiveMarkers = false
        
        for id, marker in pairs(activeMarkers) do
            if currentTime < marker.endTime then
                hasActiveMarkers = true
                
                if marker.showUI then
                    local distance = #(playerCoords - marker.coords)
                    
                    if distance < 20.0 then
                        local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(marker.coords.x, marker.coords.y, marker.coords.z + 0.2)
                        
                        if onScreen then
                            SendNUIMessage({
                                type = 'show3DCard',
                                x = screenX,
                                y = screenY,
                                data = marker.data,
                                playTime = marker.playTime,
                                distance = distance
                            })
                        end
                    end
                end
            else
                if clonedPeds[id] and DoesEntityExist(clonedPeds[id]) then
                    exports['qb-target']:RemoveTargetEntity(clonedPeds[id])
                    DeleteEntity(clonedPeds[id])
                    clonedPeds[id] = nil
                end
                activeMarkers[id] = nil
            end
        end
        
        SendNUIMessage({
            type = 'clearCards'
        })
        
        if not hasActiveMarkers then
            Wait(900) 
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for id, ped in pairs(clonedPeds) do
            if DoesEntityExist(ped) then
                exports['qb-target']:RemoveTargetEntity(ped)
                DeleteEntity(ped)
            end
        end
        
        clonedPeds = {}
        activeMarkers = {}
        
        SendNUIMessage({
            type = 'clearCards'
        })
    end
end)
