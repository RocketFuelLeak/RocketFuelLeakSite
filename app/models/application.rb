class Application < ActiveRecord::Base
    STATUS_TYPES = {
        0 => :open,
        1 => :accepted,
        2 => :declined
    }

    STATUS_IDS = STATUS_TYPES.invert

    include MailForm::Delivery

    scope :recent, -> { order(created_at: :desc) }
    scope :only_status, ->(status_type = :open) { where(status: STATUS_IDS[status_type]) }
    scope :only_without_status, ->(status_type = :open) { where.not(status: STATUS_IDS[status_type]) }
    scope :only_open, -> { only_status(:open) }
    scope :only_closed, -> { only_without_status(:open) }
    scope :only_accepted, -> { only_status(:accepted) }
    scope :only_declined, -> { only_status(:declined) }
    scope :recently_opened, -> { recent.only_open }
    scope :recently_accepted, -> { recent.only_accepted }
    scope :recently_declined, -> { recent.only_declined }

    belongs_to :user

    has_many :comments, as: :commentable, dependent: :destroy

    validates :content, presence: true
    validates :character_name, presence: true
    validates :character_realm, presence: true
    validates :character_guild, presence: true

    attributes :character_name, :character_realm, :character_guild, :created_at

    def open?
        status == STATUS_IDS[:open]
    end

    def closed?
        not open?
    end

    def accepted?
        status == STATUS_IDS[:accepted]
    end

    def declined?
        status == STATUS_IDS[:declined]
    end

    def open
        self.status = STATUS_IDS[:open]
    end

    def accept
        self.status = STATUS_IDS[:accepted]
    end

    def decline
        self.status = STATUS_IDS[:declined]
    end

    def headers
        {
            to: 'adam.hellberg95+rflapplication@gmail.com',
            subject: '[RFL] New application'
        }
    end

    # Used by MailForm
    def email
        user.email
    end

    def to_param
        "#{id}-#{character_name.parameterize}"
    end
end
