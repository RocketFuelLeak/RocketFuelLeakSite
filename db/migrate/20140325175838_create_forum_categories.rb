class CreateForumCategories < ActiveRecord::Migration
  def change
    create_table :forum_categories do |t|
      t.string :name
      t.integer :order
      t.integer :access

      t.timestamps
    end
  end
end
