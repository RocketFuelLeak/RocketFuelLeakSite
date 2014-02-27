class AddIndexOnStatusToApplication < ActiveRecord::Migration
  def change
    add_index :applications, :status
  end
end
