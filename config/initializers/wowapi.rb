require 'wow/api'

WoW.configure do |config|
    config.region = :eu
    config.realm = 'Stormreaver'
    config.guild = 'Rocket Fuel Leak'
    config.character_fields = 'guild,items'
    config.guild_fields = 'members'
end
