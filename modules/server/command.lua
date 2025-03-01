local COMMAND_CONFIG = {
    CREATE = {
        COMMAND = Configuration.Command,
        DESCRIPTION = Configuration.CommandDesc,
        ACCESS = Configuration.CommandAccess,
        EVENT = "m:propcreator:openmenu"
    },
    DELETE = {
        COMMAND = Configuration.CommandDeleteProps,
        DESCRIPTION = Configuration.CommandDeletePropsDesc,
        ACCESS = Configuration.CommandDeletePropsAccess,
        EVENT = "m:propcreator:DeleteAllProps"
    }
}

for _, config in pairs(COMMAND_CONFIG) do
    lib.addCommand(config.COMMAND, {
        help = config.DESCRIPTION,
        restricted = config.ACCESS
    }, function(source)
        TriggerClientEvent(config.EVENT, source)
    end)
end

local SCRIPT_VERSION = "1.0.0"

print([[
    __  __        _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
   |  \/  |      |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
   | \  / |______| |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
   | |\/| |______| |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
   | |  | |      | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
   |_|  |_|      |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
]])

print("Versión del script: " .. SCRIPT_VERSION)


