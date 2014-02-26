class AddClassIdToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :class_id, :integer
  end
end
