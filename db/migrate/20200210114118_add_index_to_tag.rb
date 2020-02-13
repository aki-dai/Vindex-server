class AddIndexToTag < ActiveRecord::Migration[5.2]
  def change
    add_index :tag_categories, :value, unique: true
    add_index :tags, [:movie_id, :tag_category_id], unique: true
    add_index :movies, :youtube_id, unique: true
  end
end
