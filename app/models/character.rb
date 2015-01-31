class Character < ActiveRecord::Base
    serialize :confirmation_equipment

    scope :ordered, -> { order(id: :asc) }

    belongs_to :user

    validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :realm }
    validates :realm, presence: true
    validates :guild_name, presence: true
    validates :guild_realm, presence: true

    validate :character_valid
    validate :confirmation_valid

    before_save :update_from_armory

    after_save :update_user_role

    def self.from_armory(name, realm = WoW.realm)
        character = Character.new
        begin
            wow_char = WoW::Character.find(name, realm)
            character.name = wow_char.name
            character.realm = wow_char.realm
            character.class_id = wow_char.class_id
            character.role = wow_char.role
            character.spec = wow_char.spec
            character.avatar = wow_char.thumbnail_url
            character.guild_name = wow_char.guild[:name]
            character.guild_realm = wow_char.guild[:realm]
            character.confirmed = false
            character.confirmation_equipment = wow_char.equipment.keys.sample(4)
            character.api_error = nil
        rescue WoW::APIError => e
            character.name = name
            character.api_error = e
        end
        character
    end

    def api_character
        @api_character
    end

    def api_character=(char)
        @api_character = char
    end

    def api_error
        @api_error
    end

    def api_error=(error)
        @api_error = error
    end

    def confirmation_errors
        @confirmation_errors
    end

    def confirmation_errors=(errors)
        @confirmation_errors = errors
    end

    def character_valid
        if api_error
            errors.add(:name, "API error: #{api_error}")
            errors.add(:realm, "API error: #{api_error}")
        end
    end

    def confirmation_valid
        return unless self.confirmation_errors.present?
        self.confirmation_errors.each do |slot|
            errors.add(slot, 'is still equipped')
        end
    end

    def update_from_armory
        begin
            api_character = WoW::Character.find(name, realm) unless api_character.present?
            self.class_id = api_character.class_id
            self.avatar = api_character.thumbnail_url
            self.guild_name = api_character.guild[:name]
            self.guild_realm = api_character.guild[:realm]
        rescue WoW::ApiError
            self.confirmed = false
        end
    end

    def confirm_character
        begin
            api_character = WoW::Character.find(name, realm)
            present = confirmation_equipment & api_character.equipment.keys
            self.confirmed = present.empty?
            self.confirmation_errors = present
        rescue WoW::APIError => e
            self.confirmed = false
            self.api_error = e
        end
    end

    def update_user_role
        return if self.user.is_admin? or not self.confirmed

        if guild_name == WoW.guild and guild_realm == WoW.realm
            self.user.add_role :member
        else
            self.user.remove_role :officer
            self.user.remove_role :member
        end
    end

    def profile_url
        WoW::Character.get_profile_url(name, realm)
    end

    def guild_url
        WoW::Guild.get_profile_url(guild_name, guild_realm)
    end

    def to_s
        name
    end

    def to_param
        "#{id}-#{name.parameterize}-#{realm.parameterize}"
    end
end
