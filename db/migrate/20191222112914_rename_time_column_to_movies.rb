class RenameTimeColumnToMovies < ActiveRecord::Migration[5.2]
  def change
    rename_column :movies, :time, :movie_length
    rename_column :movies, :registrator, :post_user
    add_column :movies, :uid, :string
  end
end
