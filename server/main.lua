RegisterServerEvent('m:propcreator:savepropondb', function(propname, x, y, z, rotationx, rotationy, rotationz, congelar)
    x = tonumber(string.format("%.2f", x))
    y = tonumber(string.format("%.2f", y))
    z = tonumber(string.format("%.2f", z))
    rotationx = tonumber(string.format("%.2f", rotationx))
    rotationy = tonumber(string.format("%.2f", rotationy))
    rotationz = tonumber(string.format("%.2f", rotationz))

    MySQL.insert(
    'INSERT INTO `propcreator` (propname, x, y, z, rotationx, rotationy, rotationz, freeze) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        propname,
        x,
        y,
        z,
        rotationx,
        rotationy,
        rotationz,
        congelar
    })
end)


RegisterServerEvent('m:propcreator:getprops')
AddEventHandler('m:propcreator:getprops', function()
    local source = source

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
                rz = prop.rotationz,
                freeze = prop.congelar
            }

            TriggerClientEvent("m:propcreator:showprop", source, data)
        end
    else
        print("No props found.")
    end
end)



RegisterServerEvent("m:propcreator:deleteprop")
AddEventHandler("m:propcreator:deleteprop", function(propname, x, y, z)
    x = tonumber(string.format("%.2f", x))
    y = tonumber(string.format("%.2f", y))
    z = tonumber(string.format("%.2f", z))

    MySQL.Async.execute(
        "DELETE FROM propcreator WHERE propname = @propname AND x = @x AND y = @y AND z = @z",
        {
            ['@propname'] = propname,
            ['@x'] = x,
            ['@y'] = y,
            ['@z'] = z
        },
        function(rowsChanged)
            if rowsChanged > 0 then
                print("Prop - " .. propname .. " eliminada correctamente")
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