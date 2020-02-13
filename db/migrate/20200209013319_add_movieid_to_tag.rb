class AddMovieidToTag < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :tag_category_id, :integer
    add_column :tags, :movie_id, :integer
  end
end
