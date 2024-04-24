local usingGizmo = false
local creado = false

Citizen.CreateThread(function()
    local Config = Config 
    while true do
        Citizen.Wait(0)
        if creado then
            local controls = Config.DisableKey.controls
            local numControls = #controls
            if controls and numControls > 0 then
                for i = 1, numControls do
                    DisableControlAction(0, controls[i], true)
                end
            end
        else
            Citizen.Wait(100)
        end
    end
end)

local function toggleNuiFrame(bool)
    SetNuiFocus(bool, bool)
    usingGizmo = bool
    SetNuiFocusKeepInput(bool)
    creado = bool
end




function useGizmo(handle)

    SendNUIMessage({
        action = 'setGizmoEntity',
        data = {
            handle = handle,
            position = GetEntityCoords(handle),
            rotation = GetEntityRotation(handle)
        }
    })

    toggleNuiFrame(true)

    lib.showTextUI(
        ('Current Mode: %s  \n'):format("translate") ..
        '[W]    - Translate Mode  \n' ..
        '[R]    - Rotate Mode  \n' ..
        '[LALT] - Place On Ground  \n' ..
        '[Esc]  - Done Editing  \n'
    )

    while usingGizmo do

        SendNUIMessage({
            action = 'setCameraPosition',
            data = {
                position = GetFinalRenderedCamCoord(),
                rotation = GetFinalRenderedCamRot()
            }
        })
        Wait(0)
    end

    lib.hideTextUI()

    return {
        handle = handle,
        position = GetEntityCoords(handle),
        rotation = GetEntityRotation(handle)
    }
end


if Config.Framework == "qb-core" then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        DeleteAllProps()
        Wait(1000)
        TriggerServerEvent('m:propcreator:getallprops')
    end)
elseif Config.Framework == "esx" then
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function()
        DeleteAllProps()
        Wait(1000)
        TriggerServerEvent('m:propcreator:getallprops')
    end)
else
    print("You don't have selected a framework in the config.lua")
end

RegisterNUICallback('moveEntity', function(data, cb)
    local entity = data.handle
    local position = data.position
    local rotation = data.rotation

    SetEntityCoords(entity, position.x, position.y, position.z)
    SetEntityRotation(entity, rotation.x, rotation.y, rotation.z)
    cb('ok')
end)

RegisterNUICallback('placeOnGround', function(data, cb)
    PlaceObjectOnGroundProperly(data.handle)
    cb('ok')
end)

RegisterNUICallback('finishEdit', function(data, cb)
    toggleNuiFrame(false)
    SendNUIMessage({
        action = 'setGizmoEntity',
        data = {
            handle = nil,
        }
    })
    cb('ok')
end)

RegisterNUICallback('swapMode', function(data, cb)
    lib.showTextUI(
        ('Current Mode: %s  \n'):format(data.mode) ..
        '[W]    - Translate Mode  \n' ..
        '[R]    - Rotate Mode  \n' ..
        '[LALT] - Place On Ground  \n' ..
        '[Esc]  - Done Editing  \n'
    )
    cb('ok')
end)


exports("useGizmo", useGizmo)

