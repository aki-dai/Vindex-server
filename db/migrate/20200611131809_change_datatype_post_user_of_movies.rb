class ChangeDatatypePostUserOfMovies < ActiveRecord::Migration[5.2]
  def change
    remove_column :movies, :post_time, :time
    add_column :movies, :post_time, :datetime
  end
end
