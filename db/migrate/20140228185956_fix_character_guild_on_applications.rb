class FixCharacterGuildOnApplications < ActiveRecord::Migration
  def change
    rename_column :applications, :character_guild, :character_guild_name
  end
end
