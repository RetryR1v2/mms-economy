Config = {}

Config.defaultlang = "de_lang"
Config.Debug = true

-- Script Settings

Config.FarmSpots = {
    {
        Name = 'Kanabis',
        PlantProp = 'prop_weed_01',
        Blip = { Active = true, BlipSprite = 'blip_plant', BlipScale = 1.0, Coords = vector3(-764.02, -416.49, 42.09), Name = 'Kanabis' },
        Cooldown = 15, -- Time in Sec
        Plants = {
            { Coords = vector3(-764.02, -416.49, 42.09) },
            { Coords = vector3(-762.95, -423.12, 42.11) },
            { Coords = vector3(-762.0, -429.64, 41.88) },
            { Coords = vector3(-760.27, -436.25, 41.73) },
            { Coords = vector3(-756.74, -442.98, 41.63) },
        },
        PickupTime = 3, -- Time in Sec
        Reward = { Item = 'weed' , Label = 'Kanabis', ItemMin = 3, ItemMax = 5},
    },
    {
        Name = 'Mais',
        PlantProp = 'crp_cornstalks_bb_sim',
        Blip = { Active = true, BlipSprite = 'blip_plant', BlipScale = 1.0, Coords = vector3(-840.34, -411.79, 42.02), Name = 'Mais' },
        Cooldown = 15, -- Time in Sec
        Plants = {
            { Coords = vector3(-840.34, -411.79, 42.02) },
            { Coords = vector3(-846.43, -413.59, 41.93) },
            { Coords = vector3(-843.42, -424.84, 41.63) },
            { Coords = vector3(-833.27, -432.26, 41.81) },
            { Coords = vector3(-823.94, -432.91, 41.83) },
        },
        PickupTime = 3, -- Time in Sec
        Reward = { Item = 'corn' , Label = 'Mais', ItemMin = 3, ItemMax = 5},
    },
}