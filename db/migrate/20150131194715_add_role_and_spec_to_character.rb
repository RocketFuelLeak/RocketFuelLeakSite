class AddRoleAndSpecToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :role, :string, default: 'N/A'
    add_column :characters, :spec, :string, default: 'Unknown'
  end
end
