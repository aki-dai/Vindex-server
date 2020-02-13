class TagCategory < ApplicationRecord
    has_many :tags
    has_many :movies, through: :tags

    validates :value,
        presence: true,
        uniqueness: true
end
