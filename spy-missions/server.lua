local QBCore = exports['qb-core']:GetCoreObject()


RegisterServerEvent('qb-mission:completeAllMissions')
AddEventHandler('qb-mission:completeAllMissions', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddMoney('cash', Config.MissionReward)
        TriggerClientEvent('QBCore:Notify', src, 'You received $' .. Config.MissionReward .. ' for completing all missions.', 'success')
    end
end)
