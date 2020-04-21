local interiors = Config.Interiors

distance = 1.6
timer = 0
current_int = 0

function DrawText3Ds(coords, text)
    local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
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

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        local coords = GetEntityCoords(PlayerPedId())

        for k,interior in pairs(Config.Interiors) do
            if not IsEntityDead(PlayerPedId()) then
                if GetDistanceBetweenCoords(coords, interior.EnteranceCoords, true) < distance then
                    DrawText3Ds(interior.EnteranceCoords, _U('teleport_enter'))
                    if IsControlJustReleased(0, 38) then
                        if timer == 0 then
                            DoScreenFadeOut(1000)
                            while IsScreenFadingOut() do Citizen.Wait(0) end
                            NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
                            Wait(1000)
                            SetEntityCoords(GetPlayerPed(-1), interior.ExitCoords)
                            SetEntityHeading(GetPlayerPed(-1), t)
                            NetworkFadeInEntity(GetPlayerPed(-1), 0)
                            Wait(1000)
                            current_int = i
                            timer = 5
                            SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
                            DoScreenFadeIn(1000)
                            while IsScreenFadingIn() do Citizen.Wait(0)	end
                        end
                    end
                end
                
                if GetDistanceBetweenCoords(coords, interior.ExitCoords, true) < distance then
                    if timer == 0 then
                        DoScreenFadeOut(1000)
                        while IsScreenFadingOut() do Citizen.Wait(0) end
                        NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
                        Wait(1000)
                        SetEntityCoords(GetPlayerPed(-1), interior.EnteranceCoords)
                        SetEntityHeading(GetPlayerPed(-1), t)
                        NetworkFadeInEntity(GetPlayerPed(-1), 0)
                        Wait(1000)
                        current_int = i
                        timer = 5
                        SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
                        DoScreenFadeIn(1000)
                        while IsScreenFadingIn() do Citizen.Wait(0)	end
                    end
                end
            end
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if timer > 0 then
			timer=timer-1
			if timer == 0 then current_int = 0 end
		end
	end
end)
