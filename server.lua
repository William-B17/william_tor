ESX = nil


TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)

RegisterServerEvent('w:getcrypto')
AddEventHandler('w:getcrypto', function(ID)
    local xPlayer = ESX.GetPlayerFromId(ID)
    local _source = source
    
    MySQL.Async.fetchAll('SELECT cryptocurrency FROM users WHERE identifier=@identifier', {["@identifier"] = xPlayer.identifier},
        function(result)
            local array = {
                crypto = result[1].cryptocurrency,
                id = _source,
            }
            TriggerClientEvent('w:getcrypto', _source, array)
        end)
end)

RegisterServerEvent('w:pcattemptbuy')
AddEventHandler('w:pcattemptbuy', function(item, amountcash, smsg)
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    local newmoney = 0
    
    
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
                TriggerClientEvent('w:pcsuccess', _source, smsg)
                TriggerClientEvent('w:getdelivery',_source,item)
            else
                TriggerClientEvent('w:pcfail', _source, "You don't have enough money")
            end
        end)
end)

RegisterServerEvent('w:crypto:transfer')
AddEventHandler('w:crypto:transfer', function(to, amountt,msg)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(to)
	local amount = amountt

    if(msg == "" or nil) then
        TriggerClientEvent('w:pcfail', _source, "You have to write a message in your transfer")
    else
        if(amountt == "" or nil) then
            TriggerClientEvent('w:pcfail', _source, "No amount of money added")
        else
            if(xTarget == nil or xTarget == -1) then
                TriggerClientEvent('w:pcfail', _source, "Recipient not found")
            else
                MySQL.Async.fetchAll('SELECT cryptocurrency FROM users WHERE identifier=@identifier', {["@identifier"] = xPlayer.identifier},
                    function(result1)
                        accountbalance = result1[1].cryptocurrency
                        if accountbalance < 0.001 then
                            TriggerClientEvent('w:pcfail', _source, "You don't have enough money for this transfer")
                        else
                            if tonumber(_source) == (tonumber(to)) then
                                TriggerClientEvent('w:pcfail', _source, "You cannot transfer money to yourself") 
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
                                    TriggerClientEvent("w:pcsuccess", _source,"Congrats you recived [" ..amount.."] FC via FCDesk. With a message ".. msg)
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
                                    TriggerClientEvent("w:pcfail", _source,"You successfully transfered [" ..amount.."] FC via FCDesk to [ID: ".. to.."]")

                                end)
                            end
                        end
                end)
            end
        end
    end
end)

RegisterServerEvent('w:giveplayeritem')
AddEventHandler('w:giveplayeritem', function(product)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _source = source
    xPlayer.addInventoryItem(product, 1)
end)
