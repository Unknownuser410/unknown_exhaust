ESX = exports['es_extended']:getSharedObject()

--Exhaust System--
local sounds = {}


--Get Sounds--
ESX.RegisterServerCallback("unknown_exhaust:getcarsounds", function(source, cb, plate)
	cb(sounds)
end)
------------------------


--Load Exhaustitems--
for k,v in pairs(exhaustsystems) do
    ESX.RegisterUsableItem(k, function(source)
        TriggerClientEvent("unknown_exhaust:getcardata", source, v, k) 
    end)
end
------------------


--Script Start Load Cars and Sync--
Citizen.CreateThread(function()
    Wait(500) --Debug
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles', function (result)
        for k,v in pairs(result) do
            if v.exhaust then
		        local plate = v.plate
                local exhaust = v.exhaust
                
                if sounds[plate] == nil then
                    sounds[plate] = {}
                end

                sounds[plate].carsound = exhaust
            end
        end
	end)
end)
-----------------------------


--Change Exhaust--
RegisterNetEvent("unknown_changeexhaust", function(sound, plate, item)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local veh = GetVehiclePedIsIn(GetPlayerPed(source), false)

    --Check if has Job or Skip--
    if onlyjoballowed then
        local jobfound = false
        for key, jobname in pairs(allowedjobs) do
            if xPlayer.job.name == jobname then
                jobfound = true
                break
            end
        end

        if not jobfound then
            xPlayer.showNotification(locales["notallowed"])
            return
        end
    end
    --------------------------

    if sound ~= nil and veh ~= 0 then

        --Check if Plate is registered and register--
        if sounds[plate] == nil then
            sounds[plate] = {}
        end

        sounds[plate].carsound = sound
        ----------------------------------------------


        --Database Thread--
        local result = MySQL.single.await('SELECT exhaust FROM `owned_vehicles` WHERE `plate` = ? LIMIT 1', {plate})
		if result then

            --Install default Exhaust or new Sound--
            if item == "defaultexhaust" then 
                MySQL.Async.execute("UPDATE `owned_vehicles` SET `exhaust` = ? WHERE plate = ?", {nil, plate})
            else
                MySQL.Async.execute("UPDATE `owned_vehicles` SET `exhaust` = ? WHERE plate = ?", {sound, plate})
            end
            ---------------------------------------


            --Give Item Back if was installed--
            if result.exhaust ~= nil then 
                for k,v in pairs(exhaustsystems) do
                    if v == result.exhaust then 
                        xPlayer.addInventoryItem(k, 1)
                        break
                    end
                end
            elseif result.exhaust == nil then 
                xPlayer.addInventoryItem("defaultexhaust", 1)
            end
            -------------------------------------


            --Remove Items and Notify Player--
            xPlayer.removeInventoryItem(item, 1)
		    xPlayer.showNotification(locales["installed"].." "..plate)
            -----------------------------------

            --Send Sounds to Clients--
            TriggerClientEvent("unknown_exhaust:updatesounds", -1, sounds)
        else
            xPlayer.showNotification(locales["not_owned"])
        end
    end
end)
----------------------------


--Plate Change Debug--
RegisterNetEvent("unknown:platechange", function(oldplate, newplate)
    oldplate = oldplate:match("^%s*(.-)%s*$")

    if sounds[oldplate] then
        sounds[newplate] = sounds[oldplate]
        sounds[oldplate] = nil
    end

    --Reset on all Players--
    TriggerClientEvent("unknown_exhaust:updatesounds", -1, sounds)
    -------------------------
end)
-----------------


--Version Check--
Citizen.CreateThread(function()
    local resourceName = GetCurrentResourceName()
    local currentVersion = GetResourceMetadata(resourceName, 'version', 0)

    PerformHttpRequest('https://api.github.com/repos/Unknownuser410/unknown_exhaust/releases/latest', function(error, result, headers)
        if error == 200 then
            local data = json.decode(result)  -- JSON antwort decodieren
            local latestVersion = data.tag_name  -- Die neueste Version vom GitHub Release
            local changelog = data.body or ""
            latestVersion = latestVersion:match("^v?(.*)") -- Entferne das 'v' von der GitHub-Version, falls vorhanden
            changelog = changelog:gsub("#", "") -- Entferne das '#' vom Changelog, falls vorhanden

            if latestVersion ~= currentVersion then
                print("Es gibt eine neue Version! ^1Aktuelle Version: " ..currentVersion.. "^0 | ^2Neueste Version: " ..latestVersion.."^0", "\n^2Changelog:^0\n" ..changelog)
            end
        else
            print("Fehler beim Abrufen der GitHub-Daten: " .. error)
        end
    end, 'GET')
end)
---------------------
