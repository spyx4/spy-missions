Config = {}

-- NPC configuration
Config.BossLocation = vector3(-467.7, 6288.4, 12.76)
Config.BossModel = 'g_m_m_mexboss_01' -- Model of the boss NPC

-- Mission configuration
Config.MissionReward = 3000 -- Total reward after all missions are completed
Config.Missions = {
    {
        location = vector3(-586.1, -749.25, 29.49),
        distance = 2.0,
        description = "Retrieve the package from the location.",
        pedModel = 'a_m_m_prolhost_01' -- Model of the mission NPC
    },
    {
        location = vector3(1240.37, -411.48, 68.98),
        distance = 2.0,
        description = "Deliver the package to the drop-off point.",
        pedModel = 'csb_roccopelosi'
    },
    {
        location = vector3(182.43, -1837.34, 28.1),
        distance = 2.0,
        description = "Meet the informant at the location.",
        pedModel = 'a_m_m_socenlat_01'
    },
    {
        location = vector3(-983.2, -2224.31, 8.86),
        distance = 2.0,
        description = "Steal the car from the marked spot.",
        pedModel = 'g_m_y_strpunk_01'
    },
    {
        location = vector3(-924.67, 405.68, 79.13),
        distance = 2.0,
        description = "Plant the tracker on the vehicle.",
        pedModel = 's_m_y_xmech_02'
    },
    {
        location = vector3(-1594.51, -1068.29, 13.02),
        distance = 2.0,
        description = "Return to the boss.",
        pedModel = 'ig_vagspeak'
    }
}

-- Vehicle configuration
Config.VehicleModel = 'club' -- Model of the vehicle given for the mission
Config.VehicleSpawnLocation = vector3(-512.6, 6300.34, 10.61) -- Location where the vehicle will spawn
Config.VehicleSpawnHeading = 90.0 -- Heading for the spawned vehicle
Config.VehicleKeys = "qb-vehiclekeys" -- "qb-vehiclekeys", "cd_garage"
Config.FuelResource = 'LegacyFuel' -- supports any that has a GetFuel() and SetFuel() export
