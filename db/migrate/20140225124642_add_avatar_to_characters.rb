class AddAvatarToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :avatar, :string
  end
end
