module WoW
    class Guild
        RESOURCE = "/guild/%{realm}/%{name}".freeze
        PROFILE_URL = "http://%{region}.battle.net/wow/en/guild/%{realm}/%{name}/"

        attr_accessor :name, :realm, :members

        def initialize(data)
            @name = data['name']
            @realm = data['realm']
            if data.key? 'members'
                @members = Hash.new
                data['members'].map do |member|
                    name = member['character']['name']
                    realm = member['character']['realm']
                    id = "#{name}-#{realm}"
                    @members[id] = {
                        name: name,
                        realm: realm,
                        rank: member['rank']
                    }
                end
            end
        end

        def self.find(name = WoW.guild, realm = WoW.realm, region = WoW.region, fields = WoW.guild_fields)
            resource = RESOURCE % { realm: realm, name: name }
            data = API.get(resource, {fields: fields}, region)
            new(data)
        end

        def self.get_profile_url(name = WoW.guild, realm = WoW.realm, region = WoW.region)
            PROFILE_URL % { region: region, realm: realm, name: URI.encode(name) }
        end

        def has_member?(character, realm = @realm)
            return false unless @members
            case character
            when WoW::Character
                @members.key? character.id
            else
                @members.key? WoW::Character.get_id(character, realm)
            end
        end

        def get_member(character, realm = @realm)
            return nil unless @members and has_member?(character, realm)
            case character
            when WoW::Character
                @members[character.id]
            else
                @members[WoW::Character.get_id(character, realm)]
            end
        end
    end
end
