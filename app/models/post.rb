class Post < ActiveRecord::Base
    scope :recent, -> { order(created_at: :desc) }
    scope :only_published, -> { where(published: true) }
    scope :recently_published, -> { only_published.order(published_at: :desc)}

    belongs_to :user

    has_many :comments, as: :commentable, dependent: :destroy

    validates :title, presence: true, uniqueness: { case_sensitive: false }
    validates :content, presence: true

    before_save :check_published_state

    resourcify

    def self.by_year
        recent.group_by { |post| post.created_at.beginning_of_year }
    end

    def self.by_month
        recent.group_by { |post| post.created_at.beginning_of_month }
    end

    def self.from_archive(year, month)
        i_year = year.to_i
        i_month = month.to_i
        start_date = Date.new(i_year, i_month)
        end_date = start_date.end_of_month
        where("created_at >= :start_date AND created_at <= :end_date",
            { start_date: start_date.to_formatted_s(:db), end_date: end_date.to_formatted_s(:db) })
    end

    def check_published_state
        if self.published_changed? and self.published == true
            self.published_at = Time.now
        end
    end

    def to_s
        title
    end

    def to_param
        "#{id}-#{title.parameterize}"
    end
end
