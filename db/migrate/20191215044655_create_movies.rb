class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :youtube_id
      t.string :title
      t.integer :time
      t.string :channel
      t.time   :post_time
      t.string :thumnail
      t.string :registrator

      t.timestamps
    end
  end
end
