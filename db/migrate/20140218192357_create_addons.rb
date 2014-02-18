class CreateAddons < ActiveRecord::Migration
  def change
    create_table :addons do |t|
      t.string :name
      t.string :description
      t.string :curse
      t.string :wowinterface
      t.boolean :required

      t.timestamps
    end
  end
end
