class AddLatestUserIdToTag < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :latest_user_id, :integer
  end
end
