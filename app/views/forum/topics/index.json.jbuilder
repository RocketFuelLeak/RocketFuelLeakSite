json.array!(@forum_topics) do |forum_topic|
  json.extract! forum_topic, :id, :title, :locked, :pinned, :forum_forum_id, :user_id
  json.url forum_topic_url(forum_topic, format: :json)
end
