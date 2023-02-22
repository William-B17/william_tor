RegisterNUICallback('exit', function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        status = false,
        c = "none",
    })
end)

RegisterNetEvent('wg_tor:load')
AddEventHandler('wg_tor:load', function( array )    
    SetNuiFocus(true, true)
    SendNUIMessage({
        status = true,
        c = array.crypto,
        job = array.userjob,
        darkaddress = array.darkaddress,
        transfers = array.transfers,
        mails = array.mails,
        money = array.money,
    })
end)

RegisterCommand('tor', function()
    TriggerServerEvent('wg_tor:load', GetPlayerServerId(PlayerId()))
end)

function DrawText3D(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end

local ammotrans = {
    ["weapon_pistol"] = "Pistol Ammo (50x)", 
    ["weapon_assaultrifle"] = "Rifle Ammo (50x)", 
    ["weapon_pumpshotgun"] = "Shotgun Ammo (50x)"
}

local iteminfo = {
    ["hackerDevice"] = {"hackerDevice","item",0.0088},
    ["lockpick"] = {"lockpick","item",0.0029},
    ["advancedlockpick"] = {"advancedlockpick","item",0.0059},
    ["bank_c4"] = {"bank_c4","item",0.0443},
    ["blowpipe"] = {"blowpipe","item",0.0118},

    ["WEAPON_HEAVYPISTOL"] = {"WEAPON_HEAVYPISTOL","weapon",0.561},
    ["WEAPON_REVOLVER"] = {"WEAPON_REVOLVER","weapon",0.886},
    ["weapon_pistol50"] = {"weapon_pistol50","weapon",0.532},
    ["weapon_pistol"] = {"weapon_pistol","weapon",0.443},
    ["weapon_snspistol"] = {"weapon_snspistol","weapon",0.384},
    ["WEAPON_VINTAGEPISTOL"] = {"WEAPON_VINTAGEPISTOL","weapon",0.5911},

    ["weapon_assaultrifle"] = {'weapon_assaultrifle','weapon',2.955},
    ["weapon_pumpshotgun"] = {"weapon_pumpshotgun","weapon",1.4778},
    ["weapon_sniperrifle"] = {"weapon_sniperrifle","weapon",1.773},
    ["weapon_machinepistol"] = {"weapon_machinepistol","weapon",2.068},

    ["weapon_smg"] = {"weapon_smg","ammo",0.1832},
    ["weapon_sniperrifle"] = {"weapon_sniperrifle","ammo",0.147},
    
    ["weapon_assaultrifle"] = {"weapon_assaultrifle","ammo",0.189},
    ["weapon_pistol"] = {"weapon_pistol","ammo",0.147},
    ["weapon_pumpshotgun"] = {"weapon_pumpshotgun","ammo",0.177},
}

RegisterNUICallback('buy', function(data)
    TriggerServerEvent('wg_tor:pcattemptbuy', data.typex, data.item)
end)


RegisterNetEvent('wg_tor:pcfail')
AddEventHandler('wg_tor:pcfail', function(msg)
    exports['mythic_notify']:DoLongHudText('inform', msg, { ['background-color'] = '#ff0000', ['color'] = '#ffffff' })
end)

RegisterNetEvent('wg_tor:pcsuccess')
AddEventHandler('wg_tor:pcsuccess', function(msg)
    PlaySoundFrontend(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", true)
    exports['mythic_notify']:DoLongHudText('inform', msg, { ['background-color'] = '#00A300', ['color'] = '#ffffff' })
end)

RegisterNUICallback('transfer', function(data)
    TriggerServerEvent('wg_tor:crypto:transfer', data.to, data.amountt, data.message)
end)

RegisterNUICallback('exchange', function(data)
    TriggerServerEvent('wg_tor:crypto:exchange', data.amountt)
end)

RegisterNUICallback('deletemail', function(data)
    TriggerServerEvent('wg_tor:deletemail', data.addressto,data.addressfrom,data.mailmessage)
end)

RegisterNUICallback('writemail', function(data)
    TriggerServerEvent('wg_tor:writemail', data.address,data.message)
end)

local fields = {
    {1465.603, 1316.176, 115.3758},
   --{2954.067, 2786.858, 41.47036},
   --{4883.05, -4618.409, 15.11942},
   --{-1177.354, 4925.213, 223.3849},
   --{-36.03926, 6872.895, 15.15495},
   --{391.0709, 6870.245, 5.343385},
   --{-19.93866, 6188.654, 31.29818}
}

function droppack(typex,product,x,y,z)
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
                if typex=="item" then
                    TriggerServerEvent("wg_tor:giveplayeritem",product)
                elseif typex=="weapon" then
                    TriggerServerEvent("wg_tor:giveplayerweapon",product)
                elseif typex=="ammo" then
                    AddAmmoToPed(PlayerPedId(), GetHashKey(product), 50)
                end
            end
        end
    end
end

RegisterNetEvent('wg_tor:getdelivery')
AddEventHandler('wg_tor:getdelivery', function(typex,product)
    local atfield = false
    local selectedfield = math.random(1,#fields)
    SetNewWaypoint(fields[selectedfield][1],fields[selectedfield][2])
    while not atfield do 
        Wait(1)
        local PlayerPos = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(PlayerPos, fields[selectedfield][1],fields[selectedfield][2],fields[selectedfield][3], true) <= 60 then
            droppack(typex,product,fields[selectedfield][1],fields[selectedfield][2],fields[selectedfield][3])
            atfield = true
        end
    end
end)