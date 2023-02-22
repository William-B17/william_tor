ESX = nil


TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)

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

local ammotrans = {
    ["weapon_pistol"] = "Pistol Ammo (50x)", 
    ["weapon_assaultrifle"] = "Rifle Ammo (50x)", 
    ["weapon_pumpshotgun"] = "Shotgun Ammo (50x)"
}

RegisterServerEvent('wg_tor:load')
AddEventHandler('wg_tor:load', function(ID)
    local xPlayer = ESX.GetPlayerFromId(ID)
    local _source = source
    
    local job = xPlayer.job.name
    local xsxs = string.sub(xPlayer.identifier, 15, 25) .. ".wgaddress"

    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier=@identifier', {["@identifier"] = xPlayer.identifier},
        function(result)
            if (job == "police") then
                TriggerClientEvent("wg_tor:pcfail", _source, "Police are not allowed into TOR")
            else
                if (result[1].darkaddress == nil) then
                    MySQL.Async.execute(
                        'UPDATE users SET `darkaddress` = @darkaddress WHERE identifier = @identifier',
                        {
                            ['@darkaddress'] = xsxs,
                            ['@identifier'] = xPlayer.identifier
                        }
                    )
                    local array = {
                        crypto = result[1].cryptocurrency,
                        id = _source,
                        userjob = job,
                        darkaddress = xsxs,
                        transfers = "none",
                        mails = "none",
                        money = xPlayer.getAccount('bank').money
                    }
                    TriggerClientEvent('wg_tor:load', _source, array)
                else
                    MySQL.Async.fetchAll('SELECT * FROM wgdarkmails WHERE addressto=@addressto', {
                        ["@addressto"] = xsxs
                    },
                    function(msgresults)
                        MySQL.Async.fetchAll('SELECT * FROM wgtransfers WHERE addressto=@addressto', {
                            ["@addressto"] = xsxs
                        },
                        function(transferresults)
                            if(msgresults[1] == nil and transferresults[1] == nil) then
                                local array = {
                                    crypto = result[1].cryptocurrency,
                                    id = _source,
                                    userjob = job,
                                    darkaddress = result[1].darkaddress,
                                    transfers = "none",
                                    mails = "none",
                                    money = xPlayer.getAccount('bank').money
                                }
                                TriggerClientEvent('wg_tor:load', _source, array)
                            elseif(transferresults[1] == nil) then
                                local mailstable = {}
                                for i = 1, #msgresults do
                                    table.insert(mailstable, {["addressto"] = msgresults[i].addressto, ["addressfrom"] = msgresults[i].addressfrom, ["mailmessage"] = msgresults[i].message})
                                end
                                local array = {
                                    crypto = result[1].cryptocurrency,
                                    id = _source,
                                    userjob = job,
                                    darkaddress = result[1].darkaddress,
                                    transfers = "none",
                                    mails = mailstable,
                                    money = xPlayer.getAccount('bank').money
                                }
                                TriggerClientEvent('wg_tor:load', _source, array)
                            elseif(msgresults[1]==nil) then
                                local transfertable = {}
                                for i = 1, #transferresults do
                                    table.insert(transfertable, {["addressto"] = transferresults[i].addressto, ["addressfrom"] = transferresults[i].addressfrom,["amount"] = transferresults[i].amount, ["message"] = transferresults[i].message})
                                end
                                local array = {
                                    crypto = result[1].cryptocurrency,
                                    id = _source,
                                    userjob = job,
                                    darkaddress = result[1].darkaddress,
                                    transfers = transfertable,
                                    mails = "none",
                                    money = xPlayer.getAccount('bank').money
                                }
                                TriggerClientEvent('wg_tor:load', _source, array)
                            else
                                local mailstable = {}
                                local transfertable = {}
                                for i = 1, #msgresults do
                                    table.insert(mailstable, {["addressto"] = msgresults[i].addressto, ["addressfrom"] = msgresults[i].addressfrom, ["mailmessage"] = msgresults[i].message})
                                end
                                for i = 1, #transferresults do
                                    table.insert(transfertable, {["addressto"] = transferresults[i].addressto, ["addressfrom"] = transferresults[i].addressfrom,["amount"] = transferresults[i].amount, ["message"] = transferresults[i].message})
                                end
                                local array = {
                                    crypto = result[1].cryptocurrency,
                                    id = _source,
                                    userjob = job,
                                    darkaddress = result[1].darkaddress,
                                    transfers = transfertable,
                                    mails = mailstable,
                                    money = xPlayer.getAccount('bank').money
                                }
                                TriggerClientEvent('wg_tor:load', _source, array)
                            end
                        end)
                    end)
                end
            end
        end)
end)

RegisterServerEvent('wg_tor:pcattemptbuy')
AddEventHandler('wg_tor:pcattemptbuy', function(typex, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    local newmoney = 0
    local amountcash = iteminfo[item][3]
    local msg = nil
    
    MySQL.Async.fetchAll('SELECT cryptocurrency FROM users WHERE identifier=@identifier', {["@identifier"] = xPlayer.identifier},
        function(result)
            if result[1].cryptocurrency >= amountcash then
                
                newmoney = result[1].cryptocurrency - amountcash
                MySQL.Async.execute(
                    'UPDATE users SET `cryptocurrency` = @newcryptocurrency WHERE identifier = @identifier',
                    {
                        ['@newcryptocurrency'] = newmoney,
                        ['@identifier'] = xPlayer.identifier
                    }
                )
                if typex == "ammo" then
                    msg = "You ordered ["..ammotrans[item].."]. Go to your waypoint marker to pick it up."
                else
                    msg = "You ordered a ["..item.."]. Go to your waypoint marker to pick it up."
                end
                TriggerClientEvent('wg_tor:pcsuccess', _source, msg)
                TriggerClientEvent('wg_tor:getdelivery', _source, typex, item)
            else
                TriggerClientEvent('wg_tor:pcfail', _source, "You don't have enough money")
            end
        end)
end)

RegisterServerEvent('wg_tor:crypto:transfer')
AddEventHandler('wg_tor:crypto:transfer', function(to, amountt, msg)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(to)
    local amount = amountt
    local xPlayeraddress = string.sub(xPlayer.identifier, 15, 25)..".wgaddress"
    local xTargetaddress = string.sub(xTarget.identifier, 15, 25)..".wgaddress"

    if (msg == "" or nil) then
        TriggerClientEvent('wg_tor:pcfail', _source, "You have to write a message in your transfer")
    else
        if (amountt == "" or nil) then
            TriggerClientEvent('wg_tor:pcfail', _source, "No amount of money added")
        else
            if (xTarget == nil or xTarget == -1) then
                TriggerClientEvent('wg_tor:pcfail', _source, "Recipient not found")
            else
                MySQL.Async.fetchAll('SELECT cryptocurrency FROM users WHERE identifier=@identifier', {["@identifier"] = xPlayer.identifier},
                    function(result1)
                        accountbalance = result1[1].cryptocurrency
                        if accountbalance < 0.001 then
                            TriggerClientEvent('wg_tor:pcfail', _source, "You don't have enough money for this transfer")
                        else
                            if tonumber(_source) ~= (tonumber(to)) then
                                TriggerClientEvent('wg_tor:pcfail', _source, "You cannot transfer money to yourself")
                            else
                                MySQL.Async.fetchAll('SELECT cryptocurrency FROM users WHERE identifier=@identifier', {["@identifier"] = xTarget.identifier},
                                    function(result)
                                        newmoney = result[1].cryptocurrency + amount
                                        MySQL.Async.execute(
                                            'UPDATE users SET `cryptocurrency` = @newcryptocurrency WHERE identifier = @identifier',
                                            {
                                                ['@newcryptocurrency'] = newmoney,
                                                ['@identifier'] = xTarget.identifier
                                            }
                                        )
                                        TriggerClientEvent("wg_tor:pcsuccess", _source, "Congrats you recived [" .. amount .. "] FC via FCDesk from ["..xPlayeraddress.."] With a message " .. msg)
                                    end)
                                MySQL.Async.fetchAll('SELECT cryptocurrency FROM users WHERE identifier=@identifier', {["@identifier"] = xPlayer.identifier},
                                    function(result)
                                        newmoney = result[1].cryptocurrency + amount
                                        MySQL.Async.execute(
                                            'UPDATE users SET `cryptocurrency` = @newcryptocurrency WHERE identifier = @identifier',
                                            {
                                                ['@newcryptocurrency'] = newmoney,
                                                ['@identifier'] = xPlayer.identifier
                                            }
                                        )
                                        TriggerClientEvent("wg_tor:pcfail", _source, "You successfully transfered [" .. amount .. "] FC via FCDesk to [" ..xTargetaddress.. "]")
                                    
                                    end)
                                MySQL.Async.execute('INSERT INTO wgtransfers (`addressto`, `addressfrom`,`amount`, `message`) VALUES (@addressto,@addressfrom,@amount,@message)',{
                                        ['@addressto'] = xTargetaddress,
                                        ['@addressfrom'] = xPlayeraddress,
                                        ['@amount'] = amount,
                                        ['@message'] = msg
                                    }
                                )
                            end
                        end
                    end)
            end
        end
    end
end)

function moneytocrypt(x)
    y = x/169165
    return y
end

RegisterServerEvent('wg_tor:crypto:exchange')
AddEventHandler('wg_tor:crypto:exchange', function(ex)
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    if ex == nil then
        TriggerClientEvent('wg_tor:pcfail', _source, "You didn't write a number")
    else
        if xPlayer.getAccount('bank').money == nil then
            TriggerClientEvent('wg_tor:pcfail', _source, "Wait... What?")
        else
            if xPlayer.getAccount('bank').money >= tonumber(ex) then
                local newbank = (xPlayer.getAccount('bank').money - ex)
                local cryptochange = moneytocrypt(ex)    
                MySQL.Async.fetchAll('SELECT cryptocurrency FROM users WHERE identifier=@identifier', {["@identifier"] = xPlayer.identifier},
                    function(result)
                        newcrypto = result[1].cryptocurrency + ((cryptochange/100)*90)
                        MySQL.Async.execute(
                            'UPDATE users SET `cryptocurrency` = @newcryptocurrency,`bank` = @newbank WHERE identifier = @identifier',
                            {
                                ['@newcryptocurrency'] = newcrypto,
                                ['@newbank'] = newbank,
                                ['@identifier'] = xPlayer.identifier
                            }
                        )
                end)
                TriggerClientEvent("wg_tor:pcsuccess", _source, "Congrats you exchanged ["..ex.."] $ to ["..moneytocrypt(ex).."] FC via Get Crypto.")

            else
                TriggerClientEvent('wg_tor:pcfail', _source, "You don't have enough money")
            end
        end
    end

end)

RegisterServerEvent('wg_tor:giveplayeritem')
AddEventHandler('wg_tor:giveplayeritem', function(product)
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    xPlayer.addInventoryItem(product, 1)
end)

RegisterServerEvent('wg_tor:giveplayerweapon')
AddEventHandler('wg_tor:giveplayerweapon', function(weapon)
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    xPlayer.addWeapon(weapon, 5)
end)

RegisterServerEvent('wg_tor:writemail')
AddEventHandler('wg_tor:writemail', function(address,message)
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source

    local senderaddress = string.sub(xPlayer.identifier, 15, 25) .. ".wgaddress"

    MySQL.Async.fetchAll('SELECT * FROM users WHERE darkaddress=@darkaddress', {["@darkaddress"] = address},
    function(result)
        if(result[1] == nil) then
            TriggerClientEvent('wg_tor:pcfail', _source, "That address does not exsist")
        else
            if(result[1].darkaddress ~= senderaddress) then
                TriggerClientEvent('wg_tor:pcfail', _source, "You can't send mails to your self")
            else
                if(string.len(message) <= 10) then
                    TriggerClientEvent('wg_tor:pcfail', _source, "Your message is to short (min 10)")
                else
                    MySQL.Async.execute('INSERT INTO wgdarkmails (`addressto`, `addressfrom`, `message`) VALUES (@addressto,@addressfrom,@message)',{
                            ['@addressto'] = address,
                            ['@addressfrom'] = senderaddress,
                            ['@message'] = message
                        }
                    )
                end
            end
        end
    end)
end)

RegisterServerEvent('wg_tor:deletemail')
AddEventHandler('wg_tor:deletemail', function(to,from,message)
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source

    MySQL.Async.execute('DELETE FROM wgdarkmails WHERE addressto=@addressto AND addressfrom=@addressfrom AND message=@message',{
            ['@addressto'] = to,
            ['@addressfrom'] = from,
            ['@message'] = message
        }
    )

end)
