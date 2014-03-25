class Forum::Category < ActiveRecord::Base
    scope :ordered, -> { order(order: :asc) }

    has_many :forums, class_name: "Forum::Forum", foreign_key: "forum_category_id"

    validates :name, presence: true
    validates :order, presence: true

    def to_s
        name
    end

    def to_param
        "#{id}-#{name.parameterize}"
    end
end
