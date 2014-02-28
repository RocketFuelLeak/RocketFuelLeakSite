require 'httparty'

require 'wow/constants'
require 'wow/configure'
require 'wow/character'
require 'wow/guild'

module WoW
    extend Configure

    class APIError < StandardError; end

    class API
        ENDPOINT = "%{region}.battle.net"
        PATH = "api/wow%{resource}"
        URL = "http://%{region}.battle.net/api/wow%{resource}"

        def self.get(resource, region = WoW.region)
            url = URL % { region: region, resource: URI.encode(resource) }
            data = HTTParty.get url
            raise APIError.new('Parse error, server returned non-json') unless data.content_type == "application/json"
            if data["status"] == "nok"
                raise APIError.new(data["reason"])
            end
            data
        end
    end
end
