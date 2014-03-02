require 'httparty'

require 'wowprogress/configuration'

module WoWProgress
    extend Configuration

    class APIError < StandardError; end

    class API
        URL = "http://www.wowprogress.com/guild/%{region}/%{realm}/%{guild}/json_rank"

        def self.get(region = WoWProgress.region, realm = WoWProgress.realm, guild = WoWProgress.guild)
            url = URL % { region: region, realm: URI.encode(realm), guild: URI.encode(guild) }
            data = HTTParty.get url
            raise APIError.new('Parse error, server returned invalid json') if data.parsed_response == nil
            JSON.parse(data)
        end
    end
end
