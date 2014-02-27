class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.text :content
      t.string :character_name
      t.string :character_realm
      t.string :character_guild
      t.integer :status
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
