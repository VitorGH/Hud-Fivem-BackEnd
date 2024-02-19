Player.Vehicle.Nitro = {
	Fuel = 0,
	Active = false,
	Timer = GetGameTimer() 
}

LocalPlayer["state"]["Nitro"] = false

function NitroOn() 
	if GetGameTimer() >= Player.Vehicle.Nitro.Timer and not IsPauseMenuActive() then
		if IsPedInAnyVehicle(Player.Ped) then
			Player.Vehicle.Nitro.Timer = GetGameTimer() + 1000
			local vehHandler = Player.Vehicle.Entity
			if GetPedInVehicleSeat(vehHandler, -1) == Player.Ped and GetVehicleTopSpeedModifier(vehHandler) < 50.0 then
				Player.Vehicle.Nitro.Fuel = Entity(vehHandler)["state"]["Nitro"] or 0

				if Player.Vehicle.Nitro.Fuel >= 1 and (GetEntitySpeed(vehHandler) * 2.236936) > 10 then
					Player.Vehicle.Nitro.Active = true
					while Player.Vehicle.Nitro.Active do
						if Player.Vehicle.Nitro.Fuel >= 1 then
							Player.Vehicle.Nitro.Fuel = Player.Vehicle.Nitro.Fuel - 1

							if not LocalPlayer["state"]["Nitro"] then
								LocalPlayer["state"]:set("Nitro", true, false)
								Entity(vehHandler)["state"]:set("NitroFlame", true, false)

								SetVehicleRocketBoostActive(vehHandler, true)
								SetVehicleBoostActive(vehHandler, true)
								ModifyVehicleTopSpeed(vehHandler, 50.0)
							end
						else
							if LocalPlayer["state"]["Nitro"] then
								LocalPlayer["state"]:set("Nitro", false, false)
								Entity(vehHandler)["state"]:set("NitroFlame", false, false)
								Entity(vehHandler)["state"]:set("Nitro", Player.Vehicle.Nitro.Fuel, true)

								SetVehicleRocketBoostActive(vehHandler, false)
								SetVehicleBoostActive(vehHandler, false)
								ModifyVehicleTopSpeed(vehHandler, 0.0)
								Player.Vehicle.Nitro.Active = false
							end
						end

						Wait(1)
					end
				end
			end
		end
	end
end

function NitroOff()
	if LocalPlayer["state"]["Nitro"] then
		LocalPlayer["state"]:set("Nitro", false, false)

		local vehHandler = GetLastDrivenVehicle()
		if DoesEntityExist(vehHandler) then
			Entity(vehHandler)["state"]:set("Nitro", Player.Vehicle.Nitro.Fuel, true)
			Entity(vehHandler)["state"]:set("NitroFlame", false, false)

			SetVehicleRocketBoostActive(vehHandler, false)
			SetVehicleBoostActive(vehHandler, false)
			ModifyVehicleTopSpeed(vehHandler, 0.0)
		end

		Player.Vehicle.Nitro.Active = false
	end
end

AddStateBagChangeHandler("NitroFlame", nil, function(name, key, value)
	local vehNet = parseInt(name:gsub("entity:", ""))
	if NetworkDoesNetworkIdExist(vehNet) then
		local vehHandler = NetToVeh(vehNet)
		if DoesEntityExist(vehHandler) then
			SetVehicleNitroEnabled(vehHandler, value)
		end
	end
end)

RegisterCommand("+Nitro", NitroOn)
RegisterCommand("-Nitro", NitroOff)
RegisterKeyMapping("+Nitro", "Ativação do nitro.", "keyboard", "LMENU")