local on = false

function display(bool)
    on = bool
    SetNuiFocus(on, on)
    SendNUIMessage({
        status = on,
    })
end

RegisterNUICallback('exit', function(data)
    display(false)
end)

RegisterNetEvent('w:getcrypto')
AddEventHandler('w:getcrypto', function( array )    
    SetNuiFocus(true, true)
    SendNUIMessage({
        status = true,
        c = array.crypto,
    })
end)


RegisterCommand('wbx', function()
    TriggerServerEvent('w:getcrypto', GetPlayerServerId(PlayerId()))
end)

function DrawText3D(x,y,z, text, scalex)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(scalex, scalex)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

RegisterNetEvent('w:opentor')
AddEventHandler('w:opentor', function(source)
    display(not on)
end)

RegisterCommand('tor', function(source)
    TriggerEvent('w:opentor')
end)

RegisterNUICallback('buy', function(data)
    local x = tonumber(data.price)
    local msg = "You ordered a ["..data.item.."] For ["..x.."]x FRC's. Go to your waypoint marker to pick it up."
    TriggerServerEvent('w:pcattemptbuy', data.item,x,msg)
end)


RegisterNetEvent('w:pcfail')
AddEventHandler('w:pcfail', function(msg)
    exports['mythic_notify']:DoHudText('inform', msg, { ['background-color'] = '#ff0000', ['color'] = '#ffffff' })
end)

RegisterNetEvent('w:pcsuccess')
AddEventHandler('w:pcsuccess', function(msg)
    PlaySoundFrontend(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", true)
    exports['mythic_notify']:DoLongHudText('inform', msg, { ['background-color'] = '#00A300', ['color'] = '#ffffff' })
end)

RegisterNUICallback('transfer', function(data)
    TriggerServerEvent('w:crypto:transfer', data.to, data.amountt, data.message)
end)

local fields = {
    {1465.603, 1316.176, 115.3758},
    {2954.067, 2786.858, 41.47036},
    {4883.05, -4618.409, 15.11942},
    {-1177.354, 4925.213, 223.3849},
    {-36.03926, 6872.895, 15.15495},
    {391.0709, 6870.245, 5.343385},
    {-19.93866, 6188.654, 31.29818}
}

function droppack(product,x,y,z)
    local chutehash = GetHashKey('p_cargo_chute_s')
    local packhash = GetHashKey("prop_box_wood01a")
    local landed = false
    RequestModel(packhash)
    RequestModel(chutehash)
    local pack = CreateObject(packhash, x, y, z+10.0, false, true, true)
    local chute = CreateObject(chutehash, x, y, z+15.0, false, true, true)
    Citizen.Wait(10)
    SetEntityVelocity(pack, 0.0, 0.0, -10.1)
    SetEntityVelocity(chute, 0.0, 0.0, -10.1)
    FreezeEntityPosition(pack,false)
    AttachEntityToEntity(chute, pack, 0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    Citizen.Wait(850)
    FreezeEntityPosition(pack,true)
    Citizen.Wait(100)
    DeleteObject(chute)
    landed = true
    local coords = GetEntityCoords(pack)
    while landed do 
        Wait(1)
        local PlayerPos = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(PlayerPos, coords.x,coords.y,coords.z, true) <= 5 then
            DrawText3D(coords.x,coords.y,coords.z + 0.5,"Tryk ~g~[E]~w~ for at åbne pakken",0.45)
            if IsControlJustPressed(1, 38) then
                landed = false
                DeleteObject(pack)
                TriggerServerEvent("w:giveplayeritem",product)
            end
        end
    end
end

RegisterNetEvent('w:getdelivery')
AddEventHandler('w:getdelivery', function(product)
    local atfield = false
    local selectedfield = math.random(1,#fields)
    SetNewWaypoint(fields[selectedfield][1],fields[selectedfield][2])
    while not atfield do 
        Wait(1)
        local PlayerPos = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(PlayerPos, fields[selectedfield][1],fields[selectedfield][2],fields[selectedfield][3], true) <= 50 then
            droppack(product,fields[selectedfield][1],fields[selectedfield][2],fields[selectedfield][3])
            atfield = true
        end
    end
end)