local props = {}

RegisterNetEvent("m:propcreator:opencreator", function()
    lib.registerContext({
        id = 'prop_creator_menu',
        title = 'Prop Creator Menu',
        options = {
            {
                title = 'Create Prop',
                description = 'Create a new prop on every place',
                icon = 'box',
                onSelect = function()
                    SpawnPropSelected()
                end,
            },
            {
                title = 'Delete Prop',
                description = 'Here you can delete all the props created',
                icon = 'box',
                onSelect = function()
                    GetAllProps()
                end,
            },
        }
    })
    lib.showContext('prop_creator_menu')
end)

function SpawnPropSelected()
    local input = lib.inputDialog('Prop Creator', { 'Prop Name' })

    if not input then return end

    if input then
        spawnprop(input[1])
    end
end

function spawnprop(propname)
    local playerPed = PlayerPedId()
    local offset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 0.0)
    local model = GetHashKey(propname or "prop_bench_01a")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    local object = CreateObject(model, offset.x, offset.y, offset.z, true, false, false)
    local objectPositionData = exports.m_propcreator:useGizmo(object)
    if objectPositionData then
        local x, y, z = objectPositionData.position.x, objectPositionData.position.y, objectPositionData.position.z
        local rx, ry, rz = objectPositionData.rotation.x, objectPositionData.rotation.y, objectPositionData.rotation.z
        print("Prop Created Successfully")
        TriggerServerEvent("m:propcreator:savepropondb", propname, x, y, z, rx, ry, rz)
    else
        print("Failed to create prop.")
    end
end


function GetAllProps()
    TriggerServerEvent("m:propcreator:getprops")
end

RegisterNetEvent("m:propcreator:showprop", function(data)
    table.insert(props, data)

    UpdateEventMenu()
end)


RegisterNetEvent("m:propcreator:showallprops", function(data)
    props = {}
    for _, prop in ipairs(data) do
        table.insert(props, prop)
    end
    UpdateEventMenu()
end)

function UpdateEventMenu()
    local options = {}
    for index, prop in ipairs(props) do
        table.insert(options, {
            title = "PROP - "..index,
            description = "PROP NAME : "..prop.propname.." X : "..prop.x.." Y : "..prop.y.." Z : "..prop.z,
            metadata = {
                {label = 'Rotation X', value = prop.rx},
                {label = 'Rotation Y', value = prop.ry},
                {label = 'Rotation Z', value = prop.rz}
            },
            onSelect = function()
                deleteprop(prop.propname, prop.x, prop.y, prop.z, prop.rx, prop.ry, prop.rz)
                DeleteAllProps()
                props = {}
                Wait(1000)
                TriggerServerEvent('m:propcreator:getallprops')
            end
        })
    end

    lib.registerContext({
        id = 'prop_menu',
        title = 'Props',
        menu = 'prop_menu',
        options = options
    })

    lib.showContext('prop_menu')
end


function deleteprop(propname, x, y, z, rotationx, rotationy, rotationz)
    TriggerServerEvent("m:propcreator:deleteprop", propname, x, y, z, rotationx, rotationy, rotationz)
end

RegisterNetEvent('m:propcreator:spawnprops')
AddEventHandler('m:propcreator:spawnprops', function(props)
    for _, prop in ipairs(props) do
        SpawnProp(prop.propname, prop.x, prop.y, prop.z, prop.rotationx, prop.rotationy, prop.rotationz)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        TriggerServerEvent('m:propcreator:getallprops')
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        DeleteAllProps()            
    end
end)

function SpawnProp(propname, x, y, z, rx, ry, rz)
    local model = GetHashKey(propname)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    local object = CreateObject(model, x, y, z, true, false, false)
    SetEntityRotation(object, tonumber(rx), tonumber(ry), tonumber(rz))
end

function DeleteAllProps()
    local objects = GetGamePool('CObject')
    for _, object in ipairs(objects) do
        DeleteEntity(object)
    end
end