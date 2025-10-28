fx_version 'cerulean'
game 'gta5'

author 'DW Scripts'
description 'Combat Log Detector - Fixed Version'
version '1.1.0'

lua54 'yes'

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

dependencies {
    'qb-core'
}
