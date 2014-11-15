module WoW
    module Configure
        def configure
            yield self if block_given?
        end

        def api_key
            @@api_key
        end

        def region
            @@region
        end

        def region=(region)
            @@region = region
        end

        def realm
            @@realm
        end

        def realm=(realm)
            @@realm = realm
        end

        def guild
            @@guild
        end

        def guild=(guild)
            @@guild = guild
        end

        def character_fields
            @@character_fields
        end

        def character_fields=(fields)
            @@character_fields = fields
        end

        def guild_fields
            @@guild_fields
        end

        def guild_fields=(fields)
            @@guild_fields = fields
        end
    end
end
