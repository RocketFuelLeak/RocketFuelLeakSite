class Addon < ActiveRecord::Base
    scope :alphabetically, -> { order(required: :desc, name: :asc) }

    validates :name, presence: true, uniqueness: { case_sensitive: true }
    validates :description, presence: true

    def to_param
        "#{id}-#{name.parameterize}"
    end
end
