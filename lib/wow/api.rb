require 'httparty'

require 'wow/constants'
require 'wow/configure'
require 'wow/character'
require 'wow/guild'

module WoW
    extend Configure

    class APIError < StandardError; end

    class API
        ENDPOINT = "%{region}.api.battle.net"
        PATH = "wow%{resource}"
        URL = "https://%{region}.api.battle.net/wow%{resource}?%{params}"

        def self.get(resource, parameters = {}, region = WoW.region)
            paramstring = "apikey=#{WoW.api_key}"
            unless parameters.empty?
                parameters.each do |key, value|
                    paramstring += "&#{key}=#{value}"
                end
            end
            url = URL % { region: region, resource: URI.encode(resource), params: URI.encode(paramstring) }
            data = HTTParty.get url
            raise APIError.new("Parse error, server returned non-json for #{url}") unless data.content_type == "application/json"
            raise APIError.new(data["reason"] + " (#{url})") if data["status"] == "nok"
            data
        end
    end
end
