local RSGCore = exports['rsg-core']:GetCoreObject()

-- storage prompts
Citizen.CreateThread(function()
    for _, v in pairs(Config.Storage) do
        exports['rsg-core']:createPrompt(v.storagename, v.coords, RSGCore.Shared.Keybinds['J'], 'Open ' .. v.title, {
            type = 'client',
            event = 'rsg-storage:client:openstorage',
            args = { 
                v.storagename,
                v.maxweight,
                v.slots
            },
        })
        if v.showblip == true then
            local StorageBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(StorageBlip, GetHashKey(Config.Blip.blipSprite), true)
            SetBlipScale(StorageBlip, Config.Blip.blipScale)
            Citizen.InvokeNative(0x9CB1A1623062F402, StorageBlip, Config.Blip.blipName)
        end
    end
end)

RegisterNetEvent('rsg-storage:client:openstorage', function(storagename, maxweight, slots)
    RSGCore.Functions.GetPlayerData(function(PlayerData)
    local cid = PlayerData.citizenid
    TriggerServerEvent("inventory:server:OpenInventory", "stash", storagename..cid, { maxweight, slots })
    TriggerEvent("inventory:client:SetCurrentStash", storagename..cid)
    end)
end)
