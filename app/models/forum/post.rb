class Forum::Post < ActiveRecord::Base
  belongs_to :topic, class_name: "Forum::Topic", foreign_key: "forum_topic_id"
  belongs_to :user, class_name: "User", foreign_key: "user_id"

  validates :content, presence: true

  def edited?
    updated_at > created_at
  end
end
