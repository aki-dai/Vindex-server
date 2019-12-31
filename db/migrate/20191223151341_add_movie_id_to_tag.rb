class AddMovieIdToTag < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :youtube_id, :string
    add_column :tags, :uid, :string
    add_column :tags, :user_name, :string
  end
end
