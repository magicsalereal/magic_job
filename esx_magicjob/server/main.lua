ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'magic', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'magic', _U('magic_customer'), true, true)
TriggerEvent('esx_society:registerSociety', 'magic', 'magic', 'society_magic', 'society_magic', 'society_magic', {type = 'private'})



RegisterServerEvent('esx_magicjob:getStockItem')
AddEventHandler('esx_magicjob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_magic', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_removed') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_magicjob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_magic', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_magicjob:putStockItems')
AddEventHandler('esx_magicjob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_magic', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

  end)

end)


RegisterServerEvent('esx_magicjob:getFridgeStockItem')
AddEventHandler('esx_magicjob:getFridgeStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_magic_fridge', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_removed') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_magicjob:getFridgeStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_magic_fridge', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_magicjob:putFridgeStockItems')
AddEventHandler('esx_magicjob:putFridgeStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_magic_fridge', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

  end)

end)


RegisterServerEvent('esx_magicjob:buyItem')
AddEventHandler('esx_magicjob:buyItem', function(itemName, price, itemLabel)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local qtty = xPlayer.getInventoryItem(itemName).count
    local societyAccount = nil

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_unicorn', function(account)
        societyAccount = account
    end)
    
    --if societyAccount ~= nil and societyAccount.money >= price then
        if xPlayer.canCarryItem(itemName, 1) then
           -- societyAccount.removeMoney(price)
            xPlayer.addInventoryItem(itemName, 1)
            TriggerClientEvent('esx:showNotification', _source, 'Vous avez acheter ' .. itemLabel)
        else
            TriggerClientEvent('esx:showNotification', _source, 'Vous ne pouvez stocker d\'item')
        end
    --else
    --    TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas assez dargent dans l\'entreprise')
    --end
end)

ESX.RegisterServerCallback('esx_magicjob:getVaultWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_magic', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_magicjob:addVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_magic', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_magicjob:removeVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_magic', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_magicjob:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)

ESX.RegisterUsableItem('patochebeer', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('patochebeer', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkpatochebeer', source)
	xPlayer.showNotification("Vous avez bu de la patoche beer")
end)

ESX.RegisterUsableItem('dvrcocktail', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('dvrcocktail', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkdvrcocktail', source)
	xPlayer.showNotification("Vous avez bu du dvr cocktail")
end)

ESX.RegisterUsableItem('milkdragon', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('milkdragon', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkmilkdragon', source)
	xPlayer.showNotification("Vous avez bu du milk dragon")
end)

ESX.RegisterUsableItem('duffbeer', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('duffbeer', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkduffbeer', source)
	xPlayer.showNotification("Vous avez bu de la duff beer")
end)

ESX.RegisterUsableItem('jamesbondcocktail', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('jamesbondcocktail', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkjamesbondcocktail', source)
	xPlayer.showNotification("Vous avez bu du james bond cocktail")
end)

ESX.RegisterUsableItem('scarfacecolada', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('scarfacecolada', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkscarfacecolada', source)
	xPlayer.showNotification("Vous avez bu du scarface colada")
end)

ESX.RegisterUsableItem('onepunchman', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('onepunchman', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkonepunchman', source)
	xPlayer.showNotification("Vous avez bu du one punch man")
end)

ESX.RegisterUsableItem('dragonballcocktail', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('dragonballcocktail', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkdragonballcocktail', source)
	xPlayer.showNotification("Vous avez bu du dragon ball cocktail")
end)

ESX.RegisterUsableItem('hulkcockail', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('hulkcockail', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkhulkcockail', source)
	xPlayer.showNotification("Vous avez bu du hulk cockail")
end)

ESX.RegisterUsableItem('vitodaiquiri', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('vitodaiquiri', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkvitodaiquiri', source)
	xPlayer.showNotification("Vous avez bu du vito daiquiri")
end)

ESX.RegisterUsableItem('marvelcocktail', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('marvelcocktail', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkmarvelcocktail', source)
	xPlayer.showNotification("Vous avez bu du marvel cocktail")
end)

ESX.RegisterUsableItem('yoshishooter', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('yoshishooter', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkyoshishooter', source)
	xPlayer.showNotification("Vous avez bu des yoshi shooter")
end)


AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  magiclogo()
end)

function magiclogo()
  print([[^1   

  
  $$$$\      /$$$$   |$$$$$$$$$$$$$|   |$$$$$$$$$$$$$$|   |$$$$|  |$$$$$$$$$$$$$|               
  $$$$$\    /$$$$$   |$$$$$$$$$$$$$|   |$$$$$$$$$$$$$$|   |$$$$|  |$$$$$$$$$$$$$|
  $$| $$$\/$$$ |$$   |$$$/     \$$$|   |$$                        |$$$$/
  $$|  $$$$$$  |$$   |$$$$$$$$$$$$$|   |$$  |$$$$$$$$$|   |$$$$|  |$$$$|
  $$|    $$    |$$   |$$$$$$$$$$$$$|   |$$  |$$$$$$$$$|   |$$$$|  |$$$$\
  $$|          |$$   |$$$/     \$$$|   |$$       \$$$$|   |$$$$|  |$$$$$$$$$$$$$|
  $$|          |$$   |$$$|     |$$$|   |$$$$$$$$$$$$$$|   |$$$$|  |$$$$$$$$$$$$$|


^4| Developed by Saleand |
| Powered By Magic Development |
| Versione: v2 |
| https://discord.gg/Psk6TUuVX3 |^0]])
end
SetConvar("Magic_job", "This is Server using Magic_job By Magic Development!")
---------------| Developed by saleand#7268 |---------------