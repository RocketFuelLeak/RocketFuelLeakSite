class AddIndexesToCharacters < ActiveRecord::Migration
  def change
    add_index :characters, :name
  end
end
