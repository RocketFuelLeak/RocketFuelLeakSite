class CreateForumTopics < ActiveRecord::Migration
  def change
    create_table :forum_topics do |t|
      t.string :title
      t.boolean :locked
      t.boolean :pinned
      t.belongs_to :forum_forum, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
