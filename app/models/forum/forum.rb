class Forum::Forum < ActiveRecord::Base
    scope :ordered, -> { order(order: :asc) }

    belongs_to :category, class_name: "Forum::Category", foreign_key: "forum_category_id"

    has_many :topics, class_name: "Forum::Topic", foreign_key: "forum_forum_id"

    validates :name, presence: true
    validates :description, presence: true
    validates :order, presence: true

    def last_topic
        topics.last
    end

    def last_post
        last_topic.posts.last
    end

    def to_s
        name
    end

    def to_param
        "#{id}-#{name.parameterize}"
    end
end
