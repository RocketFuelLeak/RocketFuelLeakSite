class AddRealmToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :realm, :string, index: true
  end
end
