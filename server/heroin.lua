RegisterServerEvent('esx_illegal:pickedUpPoppy')
AddEventHandler('esx_illegal:pickedUpPoppy', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canCarryItem('poppyresin', 1) then
		xPlayer.addInventoryItem('poppyresin', 1)
	else
		xPlayer.showNotification(_U('poppy_inventoryfull'))
	end
end)

RegisterServerEvent('esx_illegal:processPoppyResin')
AddEventHandler('esx_illegal:processPoppyResin', function()
	local _source = source

	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPoppyResin, xHeroin = xPlayer.getInventoryItem('poppyresin'), xPlayer.getInventoryItem('heroin')

	if xPoppyResin.count > 0 then
		if xPlayer.canSwapItem('poppyresin', 1, 'heroin', 1) then
			xPlayer.removeInventoryItem('poppyresin', 1)
			xPlayer.addInventoryItem('heroin', 1)

			xPlayer.showNotification(_U('heroin_processed'))
		else
			xPlayer.showNotification(_U('heroin_processingfull'))
		end
	else
		xPlayer.showNotification(_U('heroin_processingenough'))
	end
end)
