class AddCharacterGuildRealmToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :character_guild_realm, :string
  end
end
