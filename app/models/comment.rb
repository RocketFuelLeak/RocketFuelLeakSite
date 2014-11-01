class Comment < ActiveRecord::Base
    scope :recent, -> { order(created_at: :desc) }

    belongs_to :user
    belongs_to :commentable, polymorphic: true

    validates :content, presence: true

    after_create :notify

    def edited?
        updated_at > created_at
    end

    def notify
        return unless commentable.instance_of? Application
        CommentMailer.new_application_comment(commentable, self).deliver
    end
end
