class CreateTagCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_categories do |t|
      t.string :value
      t.integer :num
      t.timestamps
    end
  end
end
