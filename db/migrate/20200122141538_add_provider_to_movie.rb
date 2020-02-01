class AddProviderToMovie < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :provider, :string
  end
end
