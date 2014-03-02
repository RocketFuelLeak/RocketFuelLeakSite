require 'redis'
require 'json'

namespace :wowprogress do
    desc "Fetches ranking data from WoWProgress and stores it in redis"
    task update_rankings: :environment do
        begin
            rankings = WoWProgress::API.get()
            data = rankings.to_json
            redis = Redis.new
            redis.set "wowprogress", data
        rescue WoWProgress::APIError => e
            puts "wowprogress:update_rankings: APIError: #{e}"
        rescue JSON::ParserError => e
            puts "wowprogress:update_rankings JSON parse error: #{e}"
        end
    end
end
