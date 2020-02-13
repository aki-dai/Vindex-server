class Movie < ApplicationRecord
    has_many :tags
    has_many :tag_categories, through: :tags
    belongs_to :user
end
