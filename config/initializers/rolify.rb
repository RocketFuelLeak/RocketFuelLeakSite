Rolify.configure do |config|
  # Dynamic shortcuts for User class (user.is_admin? like methods). Default is: false
  # Enable this feature _after_ running rake db:migrate as it relies on the roles table
  if ActiveRecord::Base.connection.table_exists? 'roles'
    config.use_dynamic_shortcuts
  end
end
