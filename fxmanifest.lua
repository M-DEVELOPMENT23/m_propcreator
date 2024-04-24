fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author = "MANU - M-DEVELOPMENT TEAM"
ui_page 'web/dist/index.html'
version '1.0'
client_scripts {
	"client/*.lua"
}

shared_scripts {
	'shared/config.lua',
	'@ox_lib/init.lua'
}


server_scripts {
	'server/main.lua',
	'@oxmysql/lib/MySQL.lua'
}

files {
	'web/dist/index.html',
	'web/dist/**/*',
}

dependencies {
	'ox_lib'
}
