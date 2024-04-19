
RegisterServerEvent('m:propcreator:savepropondb', function(propname, x, y, z, rotationx, rotationy, rotationz)
    MySQL.insert('INSERT INTO `propcreator` (propname, x, y, z, rotationx, rotationy, rotationz) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        propname,
        x,
        y,
        z,
        rotationx,
        rotationy,
        rotationz
    })
end)

RegisterServerEvent('m:propcreator:getprops', function()
    
    local props = MySQL.Sync.fetchAll('SELECT * FROM propcreator')

    if props then
        for _, prop in ipairs(props) do
            local data = {
                propname = prop.propname,
                x = prop.x,
                y = prop.y,
                z = prop.z,
                rx = prop.rotationx,
                ry = prop.rotationy,
                rz = prop.rotationz
            }

            TriggerClientEvent("m:propcreator:showprop", -1, data)
        end
    else
        print("No props found.")
    end
end)



RegisterServerEvent("m:propcreator:deleteprop")
AddEventHandler("m:propcreator:deleteprop", function(propname, x, y, z, rotationx, rotationy, rotationz)

    MySQL.Async.execute(
        "DELETE FROM propcreator WHERE propname = @propname AND x = @x AND y = @y AND z = @z AND rotationx = @rotationx AND rotationy = @rotationy AND rotationz = @rotationz",
        {
            ['@propname'] = propname,
            ['@x'] = x,
            ['@y'] = y,
            ['@z'] = z,
            ['@rotationx'] = rotationx,
            ['@rotationy'] = rotationy,
            ['@rotationz'] = rotationz
        },
        function(rowsChanged)
            if rowsChanged > 0 then
                print("Elemento eliminado de la base de datos")
            else
                print("No se encontró ningún elemento para eliminar")
            end
        end
    )
end)


RegisterServerEvent('m:propcreator:getallprops', function()
    local props = MySQL.Sync.fetchAll('SELECT * FROM propcreator')
    if props then
        TriggerClientEvent('m:propcreator:spawnprops', -1, props)
    else
        print("No props found.")
    end
end)



lib.addCommand(Config.Command, {
    help = 'Open the prop creator',
    restricted = 'group.admin'
}, function(source, args, raw)
    TriggerClientEvent("m:propcreator:opencreator", source)
end)