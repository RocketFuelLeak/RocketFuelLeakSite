class AddDescriptionToForumForums < ActiveRecord::Migration
  def change
    add_column :forum_forums, :description, :string
  end
end
