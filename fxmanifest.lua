fx_version   'cerulean'
lua54        'yes'
game         'gta5'

--[[ Resource Information ]]--
name         'challenges_system'
author       'boynull'

--[[ Manifest ]]--
dependencies {
    'vrp',
}

shared_scripts {
    '@vrp/lib/utils.lua',
    'shared/**'
}

server_scripts {
	"server-side/utils.lua",
    "server-side/server.lua",
}

client_scripts {
    "client-side/utils.lua",
    "client-side/client.lua",
}