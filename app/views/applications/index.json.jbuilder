json.array!(@applications) do |application|
  json.extract! application, :id, :content, :character_name, :character_realm, :character_guild, :status, :user_id
  json.url application_url(application, format: :json)
end
