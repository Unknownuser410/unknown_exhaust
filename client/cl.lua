ESX = exports['es_extended']:getSharedObject()

local activated = false
local exhausts = {}

--Debug Printer--
local function debug(msg)
	if debugmode then
		print(msg)
	end
end
--------------------


-- Trim Plate for check--
local function trimAndNormalize(str)
    -- Entferne Leerzeichen am Anfang und Ende
    str = str:match("^%s*(.-)%s*$")
    -- Ersetze doppelte Leerzeichen durch ein einzelnes
    str = str:gsub("%s+", " ")
    return str
end
---------------------------------


--Get Car Data--
RegisterNetEvent("unknown_exhaust:getcardata", function(sound, item)
	local car = GetVehiclePedIsIn(PlayerPedId())

	if car > 0 then 
		local vehicleplate = ESX.Game.GetVehicleProperties(car).plate
		if sound == "default" then 
			sound = GetHashKey(car)
		end
		TriggerServerEvent("unknown_changeexhaust", sound, vehicleplate, item)
	end
end)
---------------------------


--Update Sounds on Change--
RegisterNetEvent("unknown_exhaust:updatesounds", function(soundtable)
	exhausts = soundtable
	debug("Sounds wurden geupdated")
end)
------------------------


--Load Car Sounds on Spawn--
AddEventHandler("playerSpawned", function()
	Wait(3000) --Debug
	if not activated then
		activated = true

		ESX.TriggerServerCallback("unknown_exhaust:getcarsounds", function(soundtable)
			exhausts = soundtable
		end)

		Wait(1000)

		debug("Exhaustscript geladen!")

		--Thread to Check if Player is near car and needs Sound--
        while true do 
            local cars = GetGamePool('CVehicle')

            for i = 1, #cars do
                local car = cars[i]
				local carcoords = GetEntityCoords(car)
				local pedcoords = GetEntityCoords(PlayerPedId())
                local plate = trimAndNormalize(GetVehicleNumberPlateText(car))
                for k,v in pairs(exhausts) do
                    if trimAndNormalize(k) == plate then
                        plate = k
                        if (#(pedcoords - carcoords) <= 200) and not exhausts[plate]['active'] then
							exhausts[plate]['active'] = car 
                            ForceUseAudioGameObject(car, exhausts[plate]['carsound'])
							debug("Sound ["..exhausts[plate]['carsound'].."] Set for Plate: " ..plate)
                        elseif not DoesEntityExist(exhausts[plate]['active']) or (#(pedcoords - carcoords) > 200) and exhausts[plate]['active'] or exhausts[plate]['carsound'] ~= v.carsound then 
                            exhausts[plate]['active'] = false
							debug("Sound Removed for Plate: " ..plate) 
                        end
                    end
                end
            end
            Wait(1000)
        end
        ---------------------------------

	end
end)
----------------


--Command to manually Reload Carsounds
RegisterCommand("reloadcarsounds", function()
	print("Reloaded Car Sounds!")
	exhausts = {}

	ESX.TriggerServerCallback("unknown_exhaust:getcarsounds", function(soundtable)
		exhausts = soundtable
	end)
end)
----------------------------------
