RegisterServerEvent('esx_illegal:buyLisense2')
AddEventHandler('esx_illegal:buyLisense2', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.Licenses[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)
	local money = xPlayer.getMoney()

	if money < price then
		TriggerClientEvent('esx:showNotification', source, _U('license_notenough', xItem.label))
		return
	end
	
	if xItem.count >= 1 then
		TriggerClientEvent('esx:showNotification', source, _U('license_inventoryfull'))
	else
		xPlayer.removeMoney(price)

		xPlayer.addInventoryItem(xItem.name, 1)

		TriggerClientEvent('esx:showNotification', source, _U('license_bought', xItem.label, ESX.Math.GroupDigits(price)))
	end
	
end)
