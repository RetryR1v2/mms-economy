local VORPcore = exports.vorp_core:GetCore()
local BccUtils = exports['bcc-utils'].initiate()
local progressbar = exports.vorp_progressbar:initiate()

local PlantBlips = {}
local AllPlants = {}
local PickedPlants = {}

local PlantsGroup = BccUtils.Prompts:SetupPromptGroup()
local PlantPrompt = PlantsGroup:RegisterPrompt(_U('PickupPlant'), 0x760A9C6F, 1, 1, true, 'click')-- , {timedeventhash = 'MEDIUM_TIMED_EVENT'}) -- KEY G

RegisterNetEvent('vorp:SelectedCharacter')
AddEventHandler('vorp:SelectedCharacter', function()
    Citizen.Wait(15000)
    TriggerEvent('mms-economy:client:SpawnPlantsonPlayerJoin')
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    if Config.Debug then
        TriggerEvent('mms-economy:client:SpawnPlantsonPlayerJoin')
    end
end)


RegisterNetEvent('mms-economy:client:SpawnPlantsonPlayerJoin',function()

    for h,v in pairs(Config.FarmSpots) do
        if v.Blip.Active then
            local PlantBlip = BccUtils.Blips:SetBlip(v.Blip.Name, v.Blip.BlipSprite, v.Blip.BlipScale, v.Blip.Coords.x,v.Blip.Coords.y,v.Blip.Coords.z)
            PlantBlips[#PlantBlips + 1] = PlantBlip
        end
    end

    for h,v in pairs(Config.FarmSpots) do
        local Name = v.Name
        local Prop = v.PlantProp
        local Reward = v.Reward
        local PickupTime = v.PickupTime
        local Cooldown = v.Cooldown * 1000
        for h,v in ipairs(v.Plants) do
            local Plant = CreateObject(Prop,v.Coords.x, v.Coords.y, v.Coords.z -1,true,true,false)
            PlaceEntityOnGroundProperly(Plant,true)
            local PlantData = { PlantID = Plant, Reward = Reward, Coords = v.Coords, Name = Name, Prop = Prop, Cooldown = Cooldown, PickupTime = PickupTime }
            table.insert(AllPlants,PlantData)
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(10000)
    while true do
        Wait(5)
        for h,v in pairs(AllPlants) do
            local MyPos = GetEntityCoords(PlayerPedId())
            local dist = #(MyPos - v.Coords)
            if dist < 2 then
                PlantsGroup:ShowGroup(v.Name)

                if PlantPrompt:HasCompleted() then
                    table.remove(AllPlants,h)
                    CrouchAnim()
                    Progressbar(v.PickupTime*1000,_U('PickingUp'))
                    if DoesEntityExist (v.PlantID) then
                        DeleteObject(v.PlantID)
                    end
                    TriggerServerEvent('mms-economy:server:PickupPlant',v.Reward)
                    TriggerServerEvent('mms-economy:server:UpdateTables',v.Coords)
                    table.insert(PickedPlants,v)
                end
            end
        end
    end
end)

RegisterNetEvent('mms-economy:server:UpdateTables')
AddEventHandler('mms-economy:server:UpdateTables',function(Coords)
    for h,v in ipairs(AllPlants) do
        local Index = h
        local PlantID = v.PlantID
        local Table = v
        if v.Coords == Coords then
            table.remove(AllPlants,Index)
            if DoesEntityExist (PlantID) then
                DeleteObject(PlantID)
            end
            table.insert(PickedPlants,Table)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(2000)
        if #PickedPlants > 0 then
            for h,v in pairs(PickedPlants) do
                if v.CurrentCool == nil then
                    v.CurrentCool = v.Cooldown
                elseif v.CurrentCool <= 0 then
                    v.CurrentCool = v.Cooldown
                end
                v.CurrentCool = v.CurrentCool - 2000
                if v.CurrentCool <= 0 then
                    local Plant = CreateObject(v.Prop,v.Coords.x, v.Coords.y, v.Coords.z -1,true,true,false)
                    PlaceEntityOnGroundProperly(Plant,true)
                    v.PlantID = Plant
                    table.remove(PickedPlants,h)
                    table.insert(AllPlants,v)
                end
            end
        end
    end
end)

----------------- Utilities -----------------


------ Progressbar

function Progressbar(Time,Text)
    progressbar.start(Text, Time, function ()
    end, 'linear')
    Wait(Time)
    ClearPedTasks(PlayerPedId())
end

------ Animation

function CrouchAnim()
    local dict = "script_rc@cldn@ig@rsc2_ig1_questionshopkeeper"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TaskPlayAnim(ped, dict, "inspectfloor_player", 0.5, 8.0, -1, 1, 0, false, false, false)
end

---- CleanUp on Resource Restart 

RegisterNetEvent('onResourceStop',function(resource)
    if resource == GetCurrentResourceName() then
        for _, Plant in ipairs(AllPlants) do
            DeleteObject(Plant.PlantID)
        end
        for _, Blip in ipairs(PlantBlips) do
            Blip:Remove()
        end
    end
end)