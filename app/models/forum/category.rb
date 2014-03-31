class Forum::Category < ActiveRecord::Base
    ACCESS_TYPES = {
        0 => :everyone,
        1 => :members,
        2 => :officers
    }

    VALID_ACCESS_IDS = ACCESS_TYPES.map { |k, v| k }

    ACCESS_IDS = ACCESS_TYPES.invert

    scope :ordered, -> { order(order: :asc) }

    has_many :forums, class_name: "Forum::Forum", foreign_key: "forum_category_id", dependent: :destroy

    validates :name, presence: true
    validates :order, presence: true
    validates :access, inclusion: { in: VALID_ACCESS_IDS }

    def to_s
        new_record? ? 'New category' : name
    end

    def to_param
        "#{id}-#{name.parameterize}"
    end
end
