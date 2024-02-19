Player.Stats = {
    Hunger = 100,
    Thirst = 100
}

RegisterNetEvent("hud:Thirst")
AddEventHandler("hud:Thirst",function(Number)
	if Player.Stats.Thirst ~= Number then
		Player.Stats.Thirst = Number
	end
end)

RegisterNetEvent("hud:Hunger")
AddEventHandler("hud:Hunger",function(Number)
	if Player.Stats.Hunger ~= Number then
		Player.Stats.Hunger = Number
	end
end)

Citizen.CreateThread(function()
	while true do
		if Player.Health > 200 then
            if Player.Stats.Hunger then
                if Player.Stats.Hunger >= 10 and Player.Stats.Hunger <= 20 then
                    SetFlash(0, 0, 500, 1000, 500)
                    SetEntityHealth(Player.Ped, Player.Health - 1)
                elseif Player.Stats.Hunger <= 9 then
                    SetFlash(0, 0, 500, 1000, 500)
                    SetEntityHealth(Player.Ped, Player.Health - 2)
                end
            end

            if Player.Stats.Thirst then
                if Player.Stats.Thirst >= 10 and Player.Stats.Thirst <= 20 then
                    SetFlash(0, 0, 500, 1000, 500)
                    SetEntityHealth(Player.Ped, Player.Health - 1)
                elseif Player.Stats.Thirst <= 9 then
                    SetFlash(0, 0, 500, 1000, 500)
                    SetEntityHealth(Player.Ped, Player.Health - 2)
                end
            end
		end

		Citizen.Wait(5000)
	end
end)