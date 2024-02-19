Player.Vehicle = {
    Entity = nil,

    Model = nil, 

    Speed = 0.0,

    MaxSpeed = 0.0,

    Gear = {
        Total = 6,
        Current = 1
    },

    Signal = 'off', 

    Belt = false,

    Fuel = 0,

    Engine = 100,

    RPM = 0,

    Set = function(self)
        self.Entity = GetVehiclePedIsUsing(Player.Ped)

        self.Model = GetEntityModel(self.Entity)

        self.Speed = math.floor(GetEntitySpeed(self.Entity) * 3.6)

        self.MaxSpeed = math.floor((GetVehicleEstimatedMaxSpeed(self.Entity) * 3.6) + 20)

        self.Gear.Current = GetVehicleCurrentGear(self.Entity)

        self.Gear.Total = GetVehicleHighGear(self.Entity)

        self.Fuel = math.floor(GetVehicleFuelLevel(self.Entity))

        self.Engine = math.floor(GetVehicleEngineHealth(self.Entity) / 10)

        self.RPM = math.floor(GetVehicleCurrentRpm(self.Entity) * 10000)
    
    end
}

local Belt = {
    Speed = 0,
    Velocity = vec3(0.0 , 0.0, 0.0)
} 

function SeatBelt()
    local beltStatus = Player.Vehicle.Belt
    if not IsPedOnAnyBike(Player.Ped) and not IsPedInAnyHeli(Player.Ped) and not IsPedInAnyPlane(Player.Ped) then
        if IsControlJustReleased(0, 47) then
            if beltStatus then
                Player.Vehicle.Belt = false
                TriggerEvent("sounds:Private", "beltoff", 0.5)
            else
                Player.Vehicle.Belt = true
                TriggerEvent("sounds:Private", "belton", 0.5)
            end
        end

        local veh = Player.Vehicle.Entity
        local vehSpeed = GetEntitySpeed(Player.Vehicle.Entity)

        if GetVehicleDoorLockStatus(veh) >= 2 or beltStatus then
            DisableControlAction(0, 75, true)
            DisableControlAction(27, 75, true)
        end        

        if vehSpeed ~= Belt.Speed then
            if (Belt.Speed - vehSpeed) >= 60 and not beltStatus then
                SetEntityNoCollisionEntity(Player.Ped, veh, false)
                SetEntityNoCollisionEntity(veh, Player.Ped, false)
                TriggerServerEvent("FH_Hud:VehicleEject", Belt.Velocity)

                Wait(500)

                SetEntityNoCollisionEntity(Player.Ped, veh, true)
                SetEntityNoCollisionEntity(veh, Player.Ped, true)
            end

            Belt.Velocity = GetEntityVelocity(veh)
            Belt.Speed = Belt.Speed
        end
    end
end

function IndicatorLights()
    local vehicle = Player.Vehicle.Entity
    if IsControlJustPressed(0, 10) then
        if Player.Vehicle.Signal == 'off' then
            SetVehicleIndicatorLights(vehicle, 0, true)
            Player.Vehicle.Signal = 'right'
        elseif Player.Vehicle.Signal == 'left' then
            SetVehicleIndicatorLights(vehicle, 0, true)
            SetVehicleIndicatorLights(vehicle, 1, false)
            Player.Vehicle.Signal = 'right'
        elseif Player.Vehicle.Signal == 'right' then
            SetVehicleIndicatorLights(vehicle, 0, false)
            Player.Vehicle.Signal = 'off'
        end
    elseif IsControlJustPressed(0, 11) then
        if Player.Vehicle.Signal == 'off' then
            SetVehicleIndicatorLights(vehicle, 1, true)
            Player.Vehicle.Signal = 'left'
        elseif Player.Vehicle.Signal == 'right' then
            SetVehicleIndicatorLights(vehicle, 1, true)
            SetVehicleIndicatorLights(vehicle, 0, false)
            Player.Vehicle.Signal = 'left'
        elseif Player.Vehicle.Signal == 'left' then
            SetVehicleIndicatorLights(vehicle, 1, false)
            Player.Vehicle.Signal = 'off'
        end
    end
end

CreateThread(function()
    while true do
        local idle = 1000
        if Player.Driving then
            idle = 1
            
            Player.Vehicle:Set()
            
            IndicatorLights()
            
            SeatBelt()

            if not IsMinimapRendering() then
                if Player.ActiveLocation then
                    DisplayRadar(true)
                end
            else 
                if not Player.ActiveLocation then
                    DisplayRadar(false)
                end
            end

        else

            if IsMinimapRendering() then
                DisplayRadar(false)
            end

            if Belt.Speed ~= 0 then
                Belt.Speed = 0
            end

            if Player.Vehicle.Belt then
                Player.Vehicle.Belt = false
            end

            if LocalPlayer["state"]["Nitro"] then
                NitroDisable()
            end
        end
        Wait(idle)
    end
end)