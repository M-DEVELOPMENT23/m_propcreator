local placedProps = {} 
local propsData = {}

RegisterNetEvent("m:propcreator:SpawnProps")
AddEventHandler("m:propcreator:SpawnProps", function(props)
    for _, prop in pairs(props) do
        if not propsData[prop.propid] then
            propsData[prop.propid] = prop
        end
    end
end)

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for propid, prop in pairs(propsData) do
            local distance = #(vector3(prop.x, prop.y, prop.z) - playerCoords)
            
            if distance < Configuration.DistanceLoad then
                if not placedProps[propid] then
                    RequestModel(prop.propname)
                    while not HasModelLoaded(prop.propname) do Wait(50) end

                    local obj = CreateObjectNoOffset(prop.propname, prop.x, prop.y, prop.z, false, true, false)
                    SetEntityHeading(obj, prop.heading)
                    FreezeEntityPosition(obj, prop.freeze)
                    SetEntityCollision(obj, prop.colision, true)
                    SetEntityAlpha(obj, 0, false)
                    placedProps[propid] = obj

                    CreateThread(function()
                        for alpha = 0, 255, 25 do
                            if placedProps[propid] then
                                SetEntityAlpha(placedProps[propid], alpha, false)
                                Wait(50)
                            end
                        end
                    end)
                end
            elseif placedProps[propid] then
                CreateThread(function()
                    for alpha = 255, 0, -25 do
                        if placedProps[propid] then
                            SetEntityAlpha(placedProps[propid], alpha, false)
                            Wait(50)
                        end
                    end

                    if placedProps[propid] then
                        DeleteEntity(placedProps[propid])
                        placedProps[propid] = nil
                    end
                end)
            end
        end

        Wait(2000) 
    end
end)




RegisterNetEvent("m:propcreator:DeleteAllProps")
AddEventHandler("m:propcreator:DeleteAllProps", function()
    for _, obj in pairs(placedProps) do
        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
    end
    placedProps = {}
    propsData = {}
end)


