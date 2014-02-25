module WoW
    class Guild
        RESOURCE = "/guild/%{realm}/%{name}?fields=%{fields}".freeze

        attr_accessor :name, :realm, :members

        def initialize(data)
            @name = data['name']
            @realm = data['realm']
            @members = Array.new
            if data.key? 'members' then
                data['members'].each do |member|
                    @members.push member['character']['name']
                end
            end
        end

        def self.find(name = WoW.guild, fields = WoW.guild_fields, realm = WoW.realm, region = WoW.region)
            resource = RESOURCE % { realm: realm, name: URI.encode(name), fields: fields }
            data = API.get(resource, region)
            new(data)
        end

        def has_member(character)
            if character.class == WoW::Character
                @members.include? character.name
            else
                @members.include? name
            end
        end
    end
end
