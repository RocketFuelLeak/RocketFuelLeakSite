json.extract! @user, :id, :username, :email, :provider, :uid, :confirmed_at, :created_at, :updated_at
json.character_url character_url(@user.character, format: :json) if @user.character.present?
json.application_url application_url(@user.application, format: :json) if @user.application.present?
