local cityZone = BoxZone:Create(vector3(26.23, -783.54, 44.23), 1250.0, 1500.0, {
    name="city_zone",
    offset={1.0, 1.0, 1.0},
    scale={5.0, 5.0, 5.0},
    debugPoly=false,
})

local cayoPerico = BoxZone:Create(vector3(5005.1, -4837.49, 14.29), 500.0, 500.0, {
    name="cayoPerico_zone",
    offset={1.0, 1.0, 1.0},
    scale={5.0, 5.0, 5.0},
    debugPoly=true,
})

Player = {
    Ped = nil,

    Pid = nil,

    Source = nil,

    Coords = vec(0.0, 0.0, 0.0),

    Health = nil,

    Armor = nil,

    Speaking = false,

    Mic = 1,

    ActiveLocation = true,

    Location = '',

    Zone = '',

    Gems = 0,

    Time = '00:00',

    Driving = false,

    Frequency = 0,

    Weapon = {

        Hash = nil, 

        Name = '',

        Clip = 0,

        Stock = 0,

        LastHash = nil
    },
    
    Set = function(self)
        self.Ped = PlayerPedId()

        self.Pid = PlayerId()

        self.Source = GetPlayerServerId(self.Pid)

        self.Coords = GetEntityCoords(self.Ped)

        self.Health = (GetEntityHealth(self.Ped) - 100)

        self.Armor = GetPedArmour(self.Ped)

        self.Speaking = NetworkIsPlayerTalking(self.Pid) == 1

        self.Weapon.Hash = GetSelectedPedWeapon(self.Ped)

        self.Weapon.Name = WeaponsPhotos[self.Weapon.Hash]

        self.Driving = IsPedInAnyVehicle(self.Ped)

        self.ActiveLocation = not cayoPerico:isPointInside(self.Coords)

        if self.ActiveLocation then
            self.Location = GetStreetNameFromHashKey(GetStreetNameAtCoord(self.Coords.x, self.Coords.y, self.Coords.z))
            self.Zone = cityZone:isPointInside(self.Coords) and 'Sul' or 'Norte'
        else
            self.Location = ''
            self.Zone = ''
        end
    end,

    SetTime = function(self)
        local hours = GetClockHours()
        local minutes = GetClockMinutes()
        if hours < 10 then hours = "0"..hours end
        if minutes < 10 then minutes = "0"..minutes end
        self.Time = hours..":"..minutes
    end,

    SetWeaponAmmo = function(self)
        local wHash = self.Weapon.Hash
        _, self.Weapon.Clip = GetAmmoInClip(self.Ped, wHash)
        if IsPedReloading(self.Ped) or self.Weapon.Stock <= 0 or self.Weapon.LastHash ~= wHash then
            self.Weapon.Stock = GetAmmoInPedWeapon(self.Ped, wHash) - GetMaxAmmoInClip(self.Ped, wHash, 1)
            if self.Weapon.Stock < 0 then
                self.Weapon.Stock = 0
            end
            self.Weapon.LastHash = wHash
        end
    end
}

CreateThread(function()
    while true do

        Player:Set()

        Player:SetWeaponAmmo()

        Player:SetTime()

        SendNUIMessage({
            'SetData', 
            Player.Health,
            Player.Armor,
            Player.Speaking,
            Player.Mic,
            Player.Location,

            Player.Zone,
            Player.Gems,
            Player.Stats.Hunger,
            Player.Stats.Thirst,
            Player.Time,

            Player.Weapon.Name,
            Player.Weapon.Clip,
            Player.Weapon.Stock,

            Player.Driving,
            Player.Vehicle.Gear.Total,
            Player.Vehicle.Gear.Current,
            Player.Vehicle.Signal,
            Player.Vehicle.Belt,

            Player.Vehicle.Fuel,
            Player.Vehicle.Speed,
            Player.Vehicle.MaxSpeed,
            Player.Vehicle.Engine,
            Player.Vehicle.Nitro.Fuel,

            Player.Vehicle.RPM,
            Player.Frequency,
            Player.ActiveLocation
        })
        
        Wait(10)
    end
end)

--- Usando esses eventos pois a base é fechada
RegisterNetEvent("hud:AddGemstone")
AddEventHandler("hud:AddGemstone",function(number)
	Player.Gems = Player.Gems + number
end)

RegisterNetEvent("hud:RemoveGemstone")
AddEventHandler("hud:RemoveGemstone",function(number)
	Player.Gems = Player.Gems - number

	if Player.Gems < 0 then
		Player.Gems = 0
	end
end)

-- RegisterNetEvent("FH_Hud:UpdateGems", function(gems)
--     Player.Gems = gems
-- end)

RegisterNetEvent("FH_Hud:SetFrequency", function(frequency)
    Player.Frequency = frequency
end)

RegisterNetEvent("FH_Hud:SetMicLevel", function(micLevel)
    Player.Mic = micLevel
end)