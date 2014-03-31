class Forum::Topic < ActiveRecord::Base
    scope :recent, -> { order(created_at: :desc) }
    scope :latest, -> { recent.limit(5) }

    belongs_to :forum, class_name: "Forum::Forum", foreign_key: "forum_forum_id"
    belongs_to :user, class_name: "User", foreign_key: "user_id"
  
    has_many :posts, class_name: "Forum::Post", foreign_key: "forum_topic_id", dependent: :destroy

    accepts_nested_attributes_for :posts

    validates :title, presence: true

    before_save :update_first_post
  
    def lock
        self.locked = true
    end

    def unlock
        self.locked = false
    end

    def pin
        self.pinned = true
    end

    def unpin
        self.pinned = false
    end

    def to_s
        new_record? ? 'New topic' : title
    end

    def to_param
        "#{id}-#{title.parameterize}"
    end

    private
        def update_first_post
            post = posts.first
            post.user = user
        end
end
