class Forum::Forum < ActiveRecord::Base
    ACCESS_TYPES = {
        0 => :everyone,
        1 => :members,
        2 => :officers
    }

    VALID_ACCESS_IDS = ACCESS_TYPES.map { |k, v| k }

    ACCESS_IDS = ACCESS_TYPES.invert

    scope :ordered, -> { order(order: :asc) }

    belongs_to :category, class_name: "Forum::Category", foreign_key: "forum_category_id"

    has_many :topics, class_name: "Forum::Topic", foreign_key: "forum_forum_id"

    validates :name, presence: true
    validates :description, presence: true
    validates :order, presence: true
    validates :read_access, inclusion: { in: VALID_ACCESS_IDS }
    validates :write_access, inclusion: { in: VALID_ACCESS_IDS }

    def last_topic
        topics.last
    end

    def last_post
        last_topic.posts.last
    end

    def to_s
        new_record? ? 'New forum' : name
    end

    def to_param
        "#{id}-#{name.parameterize}"
    end
end
