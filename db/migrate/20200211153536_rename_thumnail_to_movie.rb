class RenameThumnailToMovie < ActiveRecord::Migration[5.2]
  def change
    rename_column :movies, :thumnail, :thumbnail
  end
end
