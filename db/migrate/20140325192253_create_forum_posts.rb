class CreateForumPosts < ActiveRecord::Migration
  def change
    create_table :forum_posts do |t|
      t.text :content
      t.belongs_to :forum_topic, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
