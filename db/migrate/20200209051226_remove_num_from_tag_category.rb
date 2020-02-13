class RemoveNumFromTagCategory < ActiveRecord::Migration[5.2]
  def change
    remove_column :tag_categories, :num, :integer
    add_column :tag_categories, :tags_count, :integer, default: 0
  end
end
