class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.boolean :published
      t.datetime :published_at
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
