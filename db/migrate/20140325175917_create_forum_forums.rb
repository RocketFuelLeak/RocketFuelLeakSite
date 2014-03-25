class CreateForumForums < ActiveRecord::Migration
  def change
    create_table :forum_forums do |t|
      t.string :name
      t.integer :order
      t.integer :read_access
      t.integer :write_access
      t.belongs_to :forum_category, index: true

      t.timestamps
    end
  end
end
