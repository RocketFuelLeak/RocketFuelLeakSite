class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name, index: true, unique: true
      t.string :guild, index: true
      t.boolean :confirmed
      t.string :confirmation_equipment
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
