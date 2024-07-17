local QBCore = exports['qb-core']:GetCoreObject()
local onMission = false
local missionIndex = 0
local missionBlip = nil
local missionVehicle = nil
local missionPed = nil
local isAnimationPlaying = false

Citizen.CreateThread(function()
    -- Spawn the boss NPC
    RequestModel(GetHashKey(Config.BossModel))
    while not HasModelLoaded(GetHashKey(Config.BossModel)) do
        Citizen.Wait(0)
    end
    local bossPed = CreatePed(4, Config.BossModel, Config.BossLocation.x, Config.BossLocation.y, Config.BossLocation.z, 0.0, false, true)
    SetEntityHeading(bossPed, 90.0)
    FreezeEntityPosition(bossPed, true)
    SetEntityInvincible(bossPed, true)
    SetBlockingOfNonTemporaryEvents(bossPed, true)

    -- Create a blip for the boss NPC
    local bossBlip = AddBlipForCoord(Config.BossLocation)
    SetBlipSprite(bossBlip, 280)
    SetBlipDisplay(bossBlip, 4)
    SetBlipScale(bossBlip, 1.0)
    SetBlipColour(bossBlip, 1)
    SetBlipAsShortRange(bossBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mission Boss")
    EndTextCommandSetBlipName(bossBlip)

    -- Main loop to check for player interaction
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        if not onMission then
            -- Check if player is near the boss NPC
            local distance = #(playerCoords - Config.BossLocation)
            if distance < 2.0 then
                QBCore.Functions.DrawText3D(Config.BossLocation.x, Config.BossLocation.y, Config.BossLocation.z + 1.0, "[E] Talk to Boss")
                if IsControlJustReleased(0, 38) then -- E key
                    StartMission()
                end
            end
        else
            -- Check if player is near the mission location
            local distance = #(playerCoords - Config.Missions[missionIndex].location)
            if distance < Config.Missions[missionIndex].distance and not isAnimationPlaying then
                PlayMissionAnimation()
            end
        end
    end
end)

function StartMission()
    missionIndex = 1
    QBCore.Functions.Notify("Mission started. Go to the marked location.", "success")
    onMission = true
    CreateMissionBlip()
    SpawnMissionVehicle()
    SpawnMissionPed()
end

function CreateMissionBlip()
    if missionBlip then
        RemoveBlip(missionBlip)
    end
    missionBlip = AddBlipForCoord(Config.Missions[missionIndex].location)
    SetBlipSprite(missionBlip, 1)
    SetBlipColour(missionBlip, 5)
    SetBlipRoute(missionBlip, true)
    SetBlipRouteColour(missionBlip, 5)
end

function CompleteMission()
    QBCore.Functions.Notify("Mission completed: " .. Config.Missions[missionIndex].description, "success")
    missionIndex = missionIndex + 1

    if missionIndex > #Config.Missions then
        FinishAllMissions()
    else
        CreateMissionBlip()
        SpawnMissionPed()
    end
end

function FinishAllMissions()
    QBCore.Functions.Notify("All missions completed. Return to the boss for your reward.", "success")
    onMission = false
    RemoveBlip(missionBlip)
    missionBlip = nil

    -- Trigger server event to give reward
    TriggerServerEvent('qb-mission:completeAllMissions')

    -- Remove mission vehicle
    if DoesEntityExist(missionVehicle) then
        DeleteVehicle(missionVehicle)
        missionVehicle = nil
    end

    -- Remove mission ped
    if DoesEntityExist(missionPed) then
        DeletePed(missionPed)
        missionPed = nil
    end
end

function SpawnMissionVehicle()
    RequestModel(GetHashKey(Config.VehicleModel))
    while not HasModelLoaded(GetHashKey(Config.VehicleModel)) do
        Citizen.Wait(0)
    end
    missionVehicle = CreateVehicle(GetHashKey(Config.VehicleModel), Config.VehicleSpawnLocation.x, Config.VehicleSpawnLocation.y, Config.VehicleSpawnLocation.z, Config.VehicleSpawnHeading, true, false)
    SetPedIntoVehicle(PlayerPedId(), missionVehicle, -1)
    TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh)) -- qb-vehiclekeys
    -- TriggerEvent('cd_garage:AddKeys', exports['cd_garage']:GetPlate(missionVehicle)) -- cd_garage keys
end

function SpawnMissionPed()
    if missionPed then
        DeletePed(missionPed)
        missionPed = nil
    end

    local pedModel = Config.Missions[missionIndex].pedModel
    local pedLocation = Config.Missions[missionIndex].location

    RequestModel(GetHashKey(pedModel))
    while not HasModelLoaded(GetHashKey(pedModel)) do
        Citizen.Wait(0)
    end

    missionPed = CreatePed(4, pedModel, pedLocation.x, pedLocation.y, pedLocation.z - 1.0, 0.0, false, true)
    SetEntityHeading(missionPed, 90.0)
    PlaceObjectOnGroundProperly(missionPed)
    FreezeEntityPosition(missionPed, true)
    SetEntityInvincible(missionPed, true)
    SetBlockingOfNonTemporaryEvents(missionPed, true)
end

function PlayMissionAnimation()
    isAnimationPlaying = true
    local playerPed = PlayerPedId()

    -- Player animation
    RequestAnimDict("mp_common")
    while not HasAnimDictLoaded("mp_common") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 8.0, -8.0, -1, 49, 0, false, false, false)

    -- Mission ped animation
    if DoesEntityExist(missionPed) then
        TaskPlayAnim(missionPed, "mp_common", "givetake1_a", 8.0, -8.0, -1, 49, 0, false, false, false)
    end

    -- Wait for the animation to complete
    Citizen.Wait(3000)

    -- Clear animations
    ClearPedTasks(playerPed)
    if DoesEntityExist(missionPed) then
        ClearPedTasks(missionPed)
    end

    CompleteMission()
    isAnimationPlaying = false
end
