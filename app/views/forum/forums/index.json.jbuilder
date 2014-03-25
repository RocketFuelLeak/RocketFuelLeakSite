json.array!(@forum_forums) do |forum_forum|
  json.extract! forum_forum, :id, :name, :order, :read_access, :write_access, :forum/category_id
  json.url forum_forum_url(forum_forum, format: :json)
end
