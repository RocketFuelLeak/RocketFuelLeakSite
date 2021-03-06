require 'wow/api'

WoW.configure do |config|
    config.api_key = WOWAPI_CONFIG['api_key']
    config.region = :eu
    config.realm = 'Stormreaver'
    config.guild = 'Rocket Fuel Leak'
    config.character_fields = 'guild,items,talents'
    config.guild_fields = 'members'
end
