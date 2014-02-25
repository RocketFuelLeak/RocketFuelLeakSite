module WoW
    class Character
        RESOURCE = "/character/%{realm}/%{name}?fields=%{fields}".freeze
        SLOTS = [:head, :neck, :shoulder, :back, :chest, :shirt, :tabard, :wrist, :hands, :waist,
                 :legs, :feet, :finger1, :finger2, :trinket1, :trinket2, :mainHand, :offHand].freeze

        attr_accessor :name, :realm, :guild, :equipment

        def initialize(data)
            @name = data['name']
            @realm = data['realm']
            @guild = data['guild']['name'] if data.key? 'guild'
            @equipment = Hash.new
            if data.key? 'items' then
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

        def is_in_guild(guild)
            guild ||= WoW.guild
            if guild.class == WoW::Guild then
                @guild == guild.name
            else
                @guild.downcase == guild.downcase
            end
        end
    end
end
