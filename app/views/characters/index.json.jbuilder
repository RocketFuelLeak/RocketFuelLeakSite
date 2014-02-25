json.array!(@characters) do |character|
  json.extract! character, :id, :name, :guild, :confirmed, :confirmation_equipment, :user_id
  json.url character_url(character, format: :json)
end
