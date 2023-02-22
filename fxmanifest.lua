fx_version 'cerulean'

game 'gta5'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/main.js',
    'html/style.css',
    'html/img/*.png',
    'html/img/fonts/*.ttf',
    'html/img/fonts/*.otf',
    'html/img/fonts/*.woff',
}

client_scripts {
    'html/main.js',
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}