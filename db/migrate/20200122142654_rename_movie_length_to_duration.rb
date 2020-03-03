class RenameMovieLengthToDuration < ActiveRecord::Migration[5.2]
  def change
    rename_column :movies, :movie_length, :duration
  end
end
