class Forum::Topic < ActiveRecord::Base
    belongs_to :forum, class_name: "Forum::Forum", foreign_key: "forum_forum_id"
    belongs_to :user, class_name: "User", foreign_key: "user_id"
  
    has_many :posts, class_name: "Forum::Post", foreign_key: "forum_topic_id"
  
    def to_s
        title
    end

    def to_param
        "#{id}-#{title.parameterize}"
    end
end
