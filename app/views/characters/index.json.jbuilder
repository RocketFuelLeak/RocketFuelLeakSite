json.array!(@characters) do |character|
  json.extract! character, :id, :name, :avatar, :guild_name, :guild_realm, :confirmed, :user_id
  json.url character_url(character, format: :json)
end
