class AddTermsReadToUsers < ActiveRecord::Migration
  def change
    add_column :users, :terms_read, :boolean
  end
end
