class FixGuildColumnOnCharacters < ActiveRecord::Migration
  def change
    rename_column :characters, :guild, :guild_name
  end
end
