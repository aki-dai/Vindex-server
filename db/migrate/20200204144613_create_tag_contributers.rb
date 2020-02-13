class CreateTagContributers < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_contributers do |t|
      t.string :uid

      t.timestamps
    end
  end
end
