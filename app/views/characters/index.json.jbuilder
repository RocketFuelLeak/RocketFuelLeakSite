json.array!(@characters) do |character|
  json.extract! character, :id, :name, :avatar, :guild, :confirmed, :user_id
  json.url character_url(character, format: :json)
end
