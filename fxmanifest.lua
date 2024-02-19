fx_version "adamant"
game "gta5" 

server_scripts {
   "@vrp/lib/Utils.lua",
   "server.lua",
   "weather.lua"
}

client_scripts {
   "@PolyZone/client.lua",
   "@PolyZone/BoxZone.lua",
   "@vrp/lib/Utils.lua",
   "weapons_photos.lua",
   "player.lua",
   "p_vehicle.lua",
   "p_vehicle_nitro.lua",
   "p_stats.lua",
   "pop-ups.lua"
}

files {
   "nui/**/**/*",
}

ui_page "nui/index.html"