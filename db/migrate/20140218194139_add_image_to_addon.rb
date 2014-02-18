class AddImageToAddon < ActiveRecord::Migration
  def change
    add_column :addons, :image, :string
  end
end
