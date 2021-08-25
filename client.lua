local ui = {}
local activeui = {}
local thread = false
local ped = nil
local currentjob = 'all'
PlayerData = {}
active = {}
blip = {}
Citizen.CreateThread(function()
    FrameWork()
    Wait(1000)
    while true do
        Citizen.Wait(1000)
        ped = PlayerPedId()
        local coord = GetEntityCoords(PlayerPedId())
        local nearCoords = GetEntityCoords(PlayerPedId())
        for k,v in ipairs(Config.Location) do
            local dist = #(coord - vector3(v.coord.x,v.coord.y,v.coord.z))
            local job = v.job or 'all'
            if dist < v.distance and active[tonumber(k)] == nil and currentjob == job or dist < v.distance and active[tonumber(k)] == nil then
                v.id = GetGameTimer()
                active[tonumber(k)] = v.timeout or false
                Wait(100)
                if v.blip then
                    CreateBlip(v.coord.x,v.coord.y,v.coord.z,v.blip or 280,v.label,v.sender or false,v.id)
                end
                table.insert(activeui,v)
                if not thread then
                    thread = true
                    CreateUI()
                end
            elseif active[tonumber(k)] ~= nil and active[tonumber(k)] and active[tonumber(k)] <= 0 then
                active[tonumber(k)] = nil
                RemoveNuiMarker(v,k)
            elseif active[tonumber(k)] ~= nil and active[tonumber(k)] then
                active[tonumber(k)] = active[tonumber(k)] - 1
                --print(active[tonumber(k)])
            end
        end
    end
end)

function CreateUI()
    Citizen.CreateThread(function()
        while #activeui > 0 do
            Citizen.Wait(Config.Sleep)
            local coord = GetEntityCoords(ped)
            for k,v in ipairs(activeui) do
                local dist = #(coord - v.coord)
                if dist < v.distance and dist > 4 then
                    local onScreen, xxx, yyy =
                    GetScreenCoordFromWorldCoord(
                            v.coord.x + Config.CoordsX,
                            v.coord.y + Config.CoordsY,
                            v.coord.z + Config.CoordsZ)
                    if ui[k] == nil or (ui[k] * 1.05) < xxx or ui[k] > (xxx * 1.05) then
                        SendNUIMessage({
                            toggle = true,
                            x = xxx,
                            y = yyy,
                            fa = v.fa,
                            label = v.label,
                            id = v.id,
                            sleep = Config.Sleep * 0.01
                        })
                        ui[k] = xxx
                    end
                else
                    for k2,v1 in ipairs(Config.Location) do
                        if v1.id == v.id then
                            CreateThread(function()
                                if DoesBlipExist(blip[v.id]) then
                                    RemoveBlip(blip[v.id])
                                end
                            end)
                            active[tonumber(k2)] = nil
                            activeui[k] = nil
                            ui[k] = nil
                            SendNUIMessage({toggle = false,id = v1.id})
                            --print("delete")
                            break
                        end
                    end
                    activeui[k] = nil
                    ui[k] = nil
                    table.remove(activeui,k)
                    SendNUIMessage({toggle = false,id = v.id})
                    --print("delete2")
                end
            end
        end
        print("delete thread")
        SendNUIMessage({clean = true})
        thread = false
    end)
end

function AddNuiMarker(coord,fa,label,dist,job,timeout)
    table.insert(Config.Location,{coord = coord, fa = fa, label = label, distance = dist, job = job or 'all', timeout = timeout or false})
end

RegisterNetEvent('AddNuiMarker')
AddEventHandler('AddNuiMarker', function(t)
    AddNuiMarker(t.coord,t.fa,t.label,t.dist or 400,t.job,t.timeout)
end)

exports('AddNuiMarker', function(...)
    return AddNuiMarker(...)
end)

function RemoveNuiMarker(v,k)
    for k,v1 in ipairs(activeui) do
        if v1.id == v.id then
            activeui[k] = nil
            SendNUIMessage({toggle = false,id = k})
            if DoesBlipExist(blip[v.id]) then
                RemoveBlip(blip[v.id])
            end
            break
        end
    end
    if Config.Location[k].timer ~= nil then
        Config.Location[k] = nil
    end
end

RegisterNetEvent('RemoveNuiMarker')
AddEventHandler('RemoveNuiMarker', function(id)
    RemoveNuiMarker(id)
end)

exports('RemoveNuiMarker', function(...)
    return RemoveNuiMarker(...)
end)

function CreateBlip(x,y,z,sprite,text,name,i)
    local message = name.." - "..text
    blip[i] = AddBlipForCoord(x, y, z)
    SetBlipSprite (blip[i], sprite)
    SetBlipScale  (blip[i], 1.0)
    SetBlipColour (blip[i], 2)
    SetBlipAsShortRange(blip[i], false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandSetBlipName(blip[i])
end

function FrameWork()
    Citizen.CreateThread(function()
        if Config.Framework == 'ESX' then
            while ESX == nil do
                TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
                Citizen.Wait(100)
            end
    
            while PlayerData.job == nil do
                TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
                PlayerData = ESX.GetPlayerData()
                Citizen.Wait(111)
            end
    
            PlayerData = ESX.GetPlayerData()
            currentjob = PlayerData.job.name
            RegisterNetEvent('esx:playerLoaded')
            AddEventHandler('esx:playerLoaded', function(xPlayer)
                playerloaded = true
            end)
    
            RegisterNetEvent('esx:setJob')
            AddEventHandler('esx:setJob', function(job)
                PlayerData.job = job
                currentjob = PlayerData.job.name
            end)
        end
    end)
end