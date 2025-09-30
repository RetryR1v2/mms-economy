-- Server Side
local VORPcore = exports.vorp_core:GetCore()

RegisterServerEvent('mms-economy:server:PickupPlant',function(Reward)
    local src = source
    local Amount = math.random(Reward.ItemMin,Reward.ItemMax)
    local CanCarry = exports.vorp_inventory:canCarryItem(src, Reward.Item, Amount)
    if CanCarry then
        exports.vorp_inventory:addItem(src, Reward.Item, Amount)
        VORPcore.NotifyRightTip(src,_U('YouGet') .. Amount .. ' ' .. Reward.Label,8000)
    else
        VORPcore.NotifyRightTip(src,_U('PocketFull'),8000)
    end
end)

RegisterServerEvent('mms-economy:server:UpdateTables',function(Coords)
    local src = source
    for h,v in ipairs(GetPlayers()) do
        if v ~= src then
            TriggerClientEvent('mms-economy:server:UpdateTables',v,Coords)
        end
    end
end)