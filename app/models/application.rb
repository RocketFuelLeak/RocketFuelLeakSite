class Application < ActiveRecord::Base
    STATUS_TYPES = {
        0 => :open,
        1 => :accepted,
        2 => :declined
    }

    STATUS_IDS = STATUS_TYPES.invert

    scope :only_open, -> { where(status: STATUS_IDS[:open]) }
    scope :only_accepted, -> { where(status: STATUS_IDS[:accepted]) }
    scope :only_declined, -> { where(status: STATUS_IDS[:declined]) }

    belongs_to :user

    validates :content, presence: true
    validates :character_name, presence: true
    validates :character_realm, presence: true
    validates :character_guild, presence: true
    validates :verified_character, presence: true
end
