require 'httparty'

module RflUrlShortener
    class APIError < StandardError; end

    class API
        ENDPOINT = 'http://rfl.im/api/create'

        def self.get(url)
            begin
                data = { url: { long: url } }.to_json
                response = HTTParty.post ENDPOINT, {
                    body: data,
                    headers: {
                        'Content-Type' => 'application/json',
                        'Accept' => 'application/json'
                    },
                    timeout: 1
                }
                raise APIError.new('Parse error, server returned non-json') unless response.content_type == 'application/json'
                raise APIError.new(response["error"]) if response["error"]
                response["goto_url"]
            rescue HTTParty::error
                nil
            end
        end
    end
end
