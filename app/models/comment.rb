class Comment < ActiveRecord::Base
    scope :recent, -> { order(created_at: :desc) }

    belongs_to :user
    belongs_to :commentable, polymorphic: true

    validates :content, presence: true

    def edited?
        updated_at > created_at
    end
end
