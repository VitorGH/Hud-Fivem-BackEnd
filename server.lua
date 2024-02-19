local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterServerEvent("FH_Hud:VehicleEject")
AddEventHandler("FH_Hud:VehicleEject", function(velocity)
	local source = source
	local playerPed = GetPlayerPed(source)
	local playerCoords = GetEntityCoords(playerPed)

	SetEntityCoords(playerPed, playerCoords["x"], playerCoords["y"], playerCoords["z"] - 0.5, true, true, true)
	SetEntityVelocity(playerPed, velocity)

	Wait(1)

	SetPedToRagdoll(playerPed, 5000, 5000, 0, 0, 0, 0)
end)


CreateThread(function()
	while true do
		local List = vRP.Players()
		for Passport, Source in pairs(List) do
			vRP.DowngradeThirst(Passport, 2)
			vRP.DowngradeHunger(Passport, 2)
			Wait(1000)
		end
		Wait(60000)
	end
end)