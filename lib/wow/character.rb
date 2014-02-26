module WoW
    class Character
        RESOURCE = "/character/%{realm}/%{name}?fields=%{fields}".freeze
        SLOTS = [:head, :neck, :shoulder, :back, :chest, :shirt, :tabard, :wrist, :hands, :waist,
                 :legs, :feet, :finger1, :finger2, :trinket1, :trinket2, :mainHand, :offHand].freeze
        PROFILE_URL = "http://%{region}.battle.net/wow/en/character/%{realm}/%{name}/advanced"
        THUMBNAIL_URL = "http://%{region}.battle.net/static-render/%{region}/%{thumbnail}"

        attr_accessor :name, :realm, :class_id, :thumbnail, :thumbnail_url, :guild, :equipment

        def initialize(data)
            @name = data['name']
            @realm = data['realm']
            @class_id = data['class']
            @thumbnail = data['thumbnail']
            @thumbnail_url = self.class.get_thumbnail_url(@thumbnail)
            @guild = data['guild']['name'] if data.key? 'guild'
            @equipment = Hash.new
            if data.key? 'items'
                items = data['items']
                SLOTS.each do |slot|
                    @equipment[slot] = items[slot.to_s]['id'] if items.key? slot.to_s
                end
            end
        end

        def self.find(name, fields = WoW.character_fields, realm = WoW.realm, region = WoW.region)
            resource = RESOURCE % { realm: realm, name: name, fields: fields }
            data = API.get(resource, region)
            new(data)
        end

        def self.get_profile_url(name, realm = WoW.realm, region = WoW.region)
            PROFILE_URL % { region: region, realm: realm, name: URI.encode(name) }
        end

        def self.get_thumbnail_url(thumbnail, region = WoW.region)
            THUMBNAIL_URL % { region: region, thumbnail: thumbnail }
        end

        def is_in_guild(guild = WoW.guild)
            if guild.class == WoW::Guild
                @guild == guild.name
            else
                @guild.downcase == guild.downcase
            end
        end
    end
end
