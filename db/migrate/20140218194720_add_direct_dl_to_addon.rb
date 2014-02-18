class AddDirectDlToAddon < ActiveRecord::Migration
  def change
    add_column :addons, :curse_download, :string
    add_column :addons, :wowinterface_download, :string
  end
end
