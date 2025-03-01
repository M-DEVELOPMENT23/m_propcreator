local spawnedProps = {}

function LoadPropsFromDB(event)

    if event == "creator" then
        spawnedProps = {}
        local query = "SELECT * FROM mprops"
        MySQL.Async.fetchAll(query, {}, function(props)
            if props and #props > 0 then
                for _, prop in ipairs(props) do
                    spawnedProps[prop.propid] = prop
                end
                TriggerClientEvent("m:propcreator:SpawnProps", -1, spawnedProps)
            else
                print("^3[WARNING] No props found in the database.^0") 
            end
        end)
    elseif event == "delete" then
        local src = source

        MySQL.Async.fetchAll("SELECT * FROM mprops", {}, function(result)
            TriggerClientEvent('m:propcreator:createremovemenu', src, result)
        end)
    else
        print("^1[ERROR] Invalid event or source in LoadPropsFromDB.^0") -- Manejo de errores
    end
end

RegisterNetEvent("m:propcreator:RequestProps")
AddEventHandler("m:propcreator:RequestProps", function(event)
    LoadPropsFromDB(event)
end)




CreateThread(function()
    local query = [[
        SELECT COUNT(*) AS count 
        FROM information_schema.tables 
        WHERE table_schema = DATABASE() AND table_name = 'mprops'
    ]]

    MySQL.Async.fetchScalar(query, {}, function(result)
        if result and tonumber(result) > 0 then
            print("^2[INFO] ✅ Database check passed: 'mprops' table found.^0")
        else
            print("^1[ERROR] ❌ Database check failed: 'mprops' table is missing!^0")
            print("^1[ERROR] Please execute the following SQL query in your database:^0")
            print([[
                CREATE TABLE IF NOT EXISTS `mprops` (
                    `id` INT AUTO_INCREMENT PRIMARY KEY,
                    `propid` VARCHAR(50) NOT NULL,
                    `propname` VARCHAR(100) NOT NULL,
                    `x` FLOAT NOT NULL,
                    `y` FLOAT NOT NULL,
                    `z` FLOAT NOT NULL,
                    `heading` FLOAT NOT NULL,
                    `freeze` BOOLEAN NOT NULL,
                    `colision` BOOLEAN NOT NULL
                );
            ]])
        end

    end)
end)
