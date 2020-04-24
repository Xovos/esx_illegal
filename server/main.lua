ESX = nil
local CopsConnected = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_illegal:sellDrug')
AddEventHandler('esx_illegal:sellDrug', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.DrugDealerItems[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if not price then
		print(('esx_illegal: %s attempted to sell an invalid drug!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		TriggerClientEvent('esx:showNotification', source, _U('dealer_notenough'))
		return
	end

	price = ESX.Math.Round(price * amount)

	if Config.GiveBlack then
		xPlayer.addAccountMoney('black_money', price)
	else
		xPlayer.addMoney(price)
	end

	xPlayer.removeInventoryItem(xItem.name, amount)

	TriggerClientEvent('esx:showNotification', source, _U('dealer_sold', amount, xItem.label, ESX.Math.GroupDigits(price)))
end)

ESX.RegisterServerCallback('esx_illegal:buyLicense', function(source, cb, licenseName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local license = Config.LicensePrices[licenseName]

	if license == nil then
		print(('esx_illegal: %s attempted to buy an invalid license!'):format(xPlayer.identifier))
		cb(false)
	end

	if xPlayer.getMoney() >= license.price then
		xPlayer.removeMoney(license.price)

		TriggerEvent('esx_license:addLicense', source, licenseName, function()
			cb(true)
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_illegal:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.canCarryItem(item, 1))
end)

ESX.RegisterServerCallback('esx_illegal:CheckLisense', function(source, cb, itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xLisence = xPlayer.getInventoryItem(itemName)

	if xLisence.count == 1 then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_illegal:EnoughCops', function(source, cb, configvalue)	
	if CopsConnected < configvalue then
		cb(false)
		return
	else
		cb(true)
		return
	end
end)

RegisterServerEvent('esx_illegal:CountCops')
AddEventHandler('esx_illegal:CountCops', function()
	local xPlayers = ESX.GetPlayers()
	CopsConnected = 0

	for k,Player in pairs(xPlayers) do
		local xPlayer = ESX.GetPlayerFromId(Player)

		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	if Config.EnableCopCheckMessage then
		print('[',os.date("%H:%M"),']', 'esx_illegal: Counted all online cops: ', CopsConnected)
	end
end)

Citizen.CreateThread(function()
	if Config.RequireCopsOnline then
		while true do
			Citizen.Wait(Config.CopsCheckRefreshTime * 60000)
			TriggerEvent('esx_illegal:CountCops')
		end
	end
end)

Citizen.CreateThread(function()
	if Config.RequireCopsOnline then
		Citizen.Wait(5 * 60000)
		TriggerEvent('esx_illegal:CountCops')
	end
end)