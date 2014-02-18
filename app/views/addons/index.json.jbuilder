json.array!(@addons) do |addon|
  json.extract! addon, :id, :name, :description, :required, :curse, :curse_download, :wowinterface, :wowinterface_download
  json.url addon_url(addon, format: :json)
end
