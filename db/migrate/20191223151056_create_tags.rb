class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :value
      t.integer :num

      t.timestamps
    end
  end
end
