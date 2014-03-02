module WoWProgress
    module Configuration
        def configure
            yield self if block_given?
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
    end
end
