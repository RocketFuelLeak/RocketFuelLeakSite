module WoW
    class Guild
        RESOURCE = "/guild/%{realm}/%{name}?fields=%{fields}".freeze
        PROFILE_URL = "http://%{region}.battle.net/wow/en/guild/%{realm}/%{name}/"

        attr_accessor :name, :realm, :members

        def initialize(data)
            @name = data['name']
            @realm = data['realm']
            @members = Hash.new
            if data.key? 'members'
                #@members = data['members'].map { |member| { name: member['character']['name'], rank: member['rank'] } }
                data['members'].map { |member| @members[member['character']['name']] = { rank: member['rank'] } }
            end
        end

        def self.find(name = WoW.guild, fields = WoW.guild_fields, realm = WoW.realm, region = WoW.region)
            resource = RESOURCE % { realm: realm, name: name, fields: fields }
            data = API.get(resource, region)
            new(data)
        end

        def self.get_profile_url(name = WoW.guild, realm = WoW.realm, region = WoW.region)
            PROFILE_URL % { region: region, realm: realm, name: URI.encode(name) }
        end

        def has_member(character)
            if character.class == WoW::Character
                @members.include? character.name
            else
                @members.include? character
            end
        end
    end
end
