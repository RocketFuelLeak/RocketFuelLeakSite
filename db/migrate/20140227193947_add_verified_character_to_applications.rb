class AddVerifiedCharacterToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :verified_character, :boolean
  end
end
