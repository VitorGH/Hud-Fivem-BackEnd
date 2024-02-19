GlobalState["Nitro"] = {}
GlobalState["Hours"] = 12
GlobalState["Minutes"] = 0
GlobalState["Weather"] = "CLEAR"

local weatherList = { "CLEAR","EXTRASUNNY","SMOG","OVERCAST","CLOUDS","CLEARING" }

Citizen.CreateThread(function()
	while true do
		GlobalState["Minutes"] = GlobalState["Minutes"] + 1

		if GlobalState["Minutes"] >= 60 then
			GlobalState["Hours"] = GlobalState["Hours"] + 1
			GlobalState["Minutes"] = 0

			if GlobalState["Hours"] >= 24 then
				GlobalState["Hours"] = 0

				repeat
					randWeather = math.random(#weatherList)
				until GlobalState["Weather"] ~= weatherList[randWeather]

				GlobalState["Weather"] = weatherList[randWeather]
			end
		end

		Citizen.Wait(10000)
	end
end)

RegisterCommand("timeset",function(source,args,rawCommand)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.hasGroup(Passport, "Admin") then
            GlobalState["Hours"] = parseInt(args[1])
            GlobalState["Minutes"] = parseInt(args[2])

            if args[3] then
                GlobalState["Weather"] = args[3]
            end
        end
    end
end)