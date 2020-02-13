class RemoveNumFromTags < ActiveRecord::Migration[5.2]
  def change
    remove_column :tags, :num, :integer
    remove_column :tags, :uid, :string
    remove_column :tags, :user_name, :string
  end
end
