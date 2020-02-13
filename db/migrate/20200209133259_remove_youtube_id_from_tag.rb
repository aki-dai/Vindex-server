class RemoveYoutubeIdFromTag < ActiveRecord::Migration[5.2]
  def change
    remove_column :tags, :youtube_id, :string
    remove_column :tags, :value, :string
  end
end
