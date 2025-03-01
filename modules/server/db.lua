------------------------
--- Save Prop To DB ----
------------------------
RegisterNetEvent("m:propcreator:savePropPosition")
AddEventHandler("m:propcreator:savePropPosition", function(model, x, y, z, heading, collision, frozen)
    local propid = tostring(math.random(100000, 999999))

    local query = [[
        INSERT INTO mprops (propid, propname, x, y, z, freeze, colision, heading)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ]]

    MySQL.Async.execute(query, {
        propid, model, x, y, z,
        frozen and 1 or 0,  
        collision and 1 or 0, 
        heading
    })
end)

---------------------------
--- Take Props From DB ----
--- -----------------------
RegisterNetEvent("m:propcreator:TakePropsInfo")
AddEventHandler("m:propcreator:TakePropsInfo", function()
    local src = source

    local query = "SELECT * FROM mprops"

    MySQL.Async.fetchAll(query, {}, function(result)
        if result and #result > 0 then
            TriggerClientEvent("m:propcreator:ReceivePropsInfo", src, result)
        else
            TriggerClientEvent("m:propcreator:ReceivePropsInfo", src, {})
        end
    end)
end)
------------------------------
--- Removes Specific Prop ----
------------------------------
RegisterNetEvent('m:propcreator:RemoveProp')
AddEventHandler('m:propcreator:RemoveProp', function(propid)

    local query = "DELETE FROM mprops WHERE propid = @propid"

    MySQL.Async.execute(query, { ['@propid'] = propid })

    TriggerClientEvent("m:propcreator:DeleteAllProps", -1)
end)
------------------------------
--- Removes All Prop ---------
------------------------------
RegisterNetEvent('m:propcreator:RemoveAllProps')
AddEventHandler('m:propcreator:RemoveAllProps', function()
    local query = "DELETE FROM mprops"

    MySQL.Async.execute(query, {})

    TriggerClientEvent("m:propcreator:DeleteAllProps", -1)
end)