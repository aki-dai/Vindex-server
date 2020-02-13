class TagContributer < ApplicationRecord
    belongs_to :tags
    has_many :users
end
