local loadedModels = {}

function ShowPropCreatorMenu()
    lib.registerContext({
        id = 'prop_creator_menu',
        title = Configuration.Translations.MenuTitle,
        options = {
            {
                title = Configuration.Translations.CreateProp,
                description = Configuration.Translations.CreatePropDesc,
                icon = 'box',
                onSelect = OpenPropInput, 
            },
            {
                title = Configuration.Translations.DeleteProps,
                description = Configuration.Translations.DeletePropsDesc,
                icon = 'trash',
                onSelect = ShowDeleteMenu, 
            },
        },
    })
    lib.showContext('prop_creator_menu')
end

 function OpenPropInput()
    local input = lib.inputDialog(Configuration.Translations.PropDialogTitle, {
        { type = 'input', label = Configuration.Translations.PropID, description = Configuration.Translations.PropIDDesc, required = true, min = 3, max = 20 },
        { type = 'input', label = Configuration.Translations.PropName, description = Configuration.Translations.PropNameDesc, required = true, min = 3, max = 50 },
        { type = 'checkbox', label = Configuration.Translations.PropFreeze, description = Configuration.Translations.PropFreezeDesc, required = false },
        { type = 'checkbox', label = Configuration.Translations.PropColisions, description = Configuration.Translations.PropColisionsDesc, required = false },
    })

    if input then StartPropPlacement(input) end
end

 function ShowDeleteMenu()
    lib.registerContext({
        id = 'prop_delete_menu',
        title = Configuration.Translations.RemovePropsMenuTitle,
        options = {
            {
                title = Configuration.Translations.RemoveSpecificProp,
                description = Configuration.Translations.RemoveSpecificPropDesc,
                icon = 'box',
                onSelect = function()
                    TriggerServerEvent("m:propcreator:RequestProps", "delete")
                end,
            },
            {
                title = Configuration.Translations.RemoveAllProps,
                description = Configuration.Translations.RemoveAllPropsDesc,
                icon = 'trash',
                onSelect = function()
                    local confirm = lib.alertDialog({
                        header = Configuration.Translations.ConfirmDeleteHeader,
                        content = Configuration.Translations.ConfirmDeleteContent,
                        centered = true,
                        cancel = true,
                    })

                    if confirm then
                        TriggerEvent("m:propcreator:DeleteAllProps")
                        TriggerServerEvent("m:propcreator:RemoveAllProps")
                    end
                end,
            },
        },
    })
    lib.showContext('prop_delete_menu')
end

function StartPropPlacement(input)
    local modelName = input[1]

    if not loadedModels[modelName] then
        if not IsModelInCdimage(modelName) then
            return lib.notify({ description = "El modelo de prop no es válido.", type = 'error' })
        end

        RequestModel(modelName)
        while not HasModelLoaded(modelName) do Wait(100) end
        loadedModels[modelName] = true 
    end

    local playerPed = PlayerPedId()
    local forwardVector = GetEntityForwardVector(playerPed)
    local playerCoords = GetEntityCoords(playerPed)

    local propCoords = vector3(playerCoords.x + forwardVector.x * 1.5, playerCoords.y + forwardVector.y * 1.5, playerCoords.z)
    local prop = CreateObjectNoOffset(modelName, propCoords.x, propCoords.y, propCoords.z, false, false, false)

    SetEntityCollision(prop, true, true)
    SetEntityAlpha(prop, 200, false)
    FreezeEntityPosition(prop, true)

    local editing = true

    lib.showTextUI(Configuration.Translations.ControlsUI)

    Citizen.CreateThread(function()
        while DoesEntityExist(prop) and editing do
            Citizen.Wait(0)
            local x, y, z = table.unpack(GetEntityCoords(prop))
            local heading = GetEntityHeading(prop)

            if Configuration.Debug then
                print(string.format("Posición del prop:\nX=%.2f\nY=%.2f\nZ=%.2f\nHeading=%.2f", x, y, z, heading))
            end

            if IsControlPressed(0, 172) then SetEntityCoords(prop, x, y + 0.1, z)
            elseif IsControlPressed(0, 173) then SetEntityCoords(prop, x, y - 0.1, z)
            elseif IsControlPressed(0, 174) then SetEntityCoords(prop, x - 0.1, y, z)
            elseif IsControlPressed(0, 175) then SetEntityCoords(prop, x + 0.1, y, z)
            elseif IsControlPressed(0, 44) then SetEntityCoords(prop, x, y, z + 0.1)
            elseif IsControlPressed(0, 38) then SetEntityCoords(prop, x, y, z - 0.1)
            elseif IsControlPressed(0, 241) then SetEntityHeading(prop, heading + 1.5)
            elseif IsControlPressed(0, 242) then SetEntityHeading(prop, heading - 1.5)
            elseif IsControlPressed(0, 19) then
                local playerZ = GetEntityCoords(playerPed)
                SetEntityCoords(prop, x, y, playerZ.z - 1.0)
            elseif IsControlJustPressed(0, 322) then
                editing = false
                lib.hideTextUI()
                FreezeEntityPosition(prop, false)
                SetEntityCollision(prop, true, true)

                local finalCoords = GetEntityCoords(prop)
                local finalHeading = GetEntityHeading(prop)
                TriggerEvent("m:propcreator:DeleteAllProps")
                TriggerServerEvent("m:propcreator:savePropPosition", modelName, finalCoords.x, finalCoords.y, finalCoords.z, finalHeading, input[3], input[4])
                Citizen.Wait(100)
                DeleteEntity(prop)
                Wait(1000)
                TriggerServerEvent("m:propcreator:RequestProps", "creator")
            end
        end
    end)
end

