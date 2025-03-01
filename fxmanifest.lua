fx_version 'cerulean'
game 'gta5'
lua54 'true'
author 'M-DEVELOPMENT'
description 'Prop Creator for FiveM'
version '1.0.0'

client_scripts {
    'modules/client/events.lua',
    'modules/client/functions.lua',
    'modules/client/spawn.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'configuration/config.lua',
}

server_scripts {
    'modules/server/db.lua',
    'modules/server/command.lua',
    'modules/server/load.lua',
    '@oxmysql/lib/MySQL.lua'
}

escrow_ignore {
    'configuration/config.lua',
}

dependencies {
    'oxmysql',
    'ox_lib'
}