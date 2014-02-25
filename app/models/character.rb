class Character < ActiveRecord::Base
    serialize :confirmation_equipment

    belongs_to :user

    validates :name, presence: true, uniqueness: { case_sensitive: false }

    validate :character_valid
    validate :confirmation_valid

    def self.from_armory(name)
        character = Character.new
        begin
            api_character = WoW::Character.find(name)
            character.name = api_character.name
            character.avatar = api_character.thumbnail_url
            character.guild = api_character.guild
            character.confirmed = false
            character.confirmation_equipment = api_character.equipment.keys.sample(4)
            character.api_error = nil
        rescue WoW::APIError => e
            character.name = name
            character.api_error = e
        end
        character
    end

    def api_error
        @api_error
    end

    def api_error=(error)
        @api_error = error
    end

    def confirmation_error
        @confirmation_error
    end

    def confirmation_error=(error)
        @confirmation_error = error
    end

    def character_valid
        errors.add(:name, "API error: #{api_error}") if api_error
    end

    def confirmation_valid
        puts "confirmation_valid: confirmation_error == #{confirmation_error}"
        errors.add(:base, confirmation_error) if confirmation_error
    end

    def update_from_armory
        character = WoW::Character.find(name)
        avatar = character.thumbnail_url
        guild = character.guild
    end

    def confirm_character
        begin
            api_character = WoW::Character.find(name)
            confirmed = (confirmation_equipment & api_character.equipment.keys).empty?
            if confirmed == false
                puts "Setting confirmation_error"
                confirmation_error = 'Failed to confirm character, are you sure you took off the require gear?'
            end
            puts "confirmation_error: #{confirmation_error}"
        rescue WoW::APIError => e
            api_error = e
        end
    end

    def profile_url
        WoW::Character.get_profile_url(name)
    end

    def to_s
        name
    end

    def to_param
        "#{id}-#{name.parameterize}"
    end
end
