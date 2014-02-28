class AddGuildRealmToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :guild_realm, :string
  end
end
