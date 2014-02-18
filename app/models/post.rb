class Post < ActiveRecord::Base
  scope :recent, -> { order(created_at: :desc) }
  scope :only_published, -> { where(published: true) }
  scope :recently_published, -> { only_published.order(published_at: :desc)}

  belongs_to :user

  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :content, presence: true

  def to_param
    "#{id}-#{title.parameterize}"
  end
end
