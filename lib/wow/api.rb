require 'wow/configure'
require 'wow/character'
require 'wow/guild'

module WoW
    extend Configure

    class API
        ENDPOINT = "%{region}.battle.net".freeze
        PATH = "api/wow%{resource}".freeze
        URL = "http://%{region}.battle.net/api/wow%{resource}".freeze

        def self.get(resource, region = WoW.region)
            url = URL % { region: region, resource: resource }
            HTTParty.get url
        end
    end
end
