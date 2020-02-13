class Tag < ApplicationRecord
    belongs_to :tag_category, counter_cache: true
    belongs_to :movie
    has_and_belongs_to_many :users
end
