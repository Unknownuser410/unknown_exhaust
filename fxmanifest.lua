fx_version "cerulean"
game "gta5"

author "Unknown_user410"
description "Exhaustscript"
version "1.0.0"

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/cl.lua',
}

server_script {
    "@oxmysql/lib/MySQL.lua",
    'server/sv.lua',
}