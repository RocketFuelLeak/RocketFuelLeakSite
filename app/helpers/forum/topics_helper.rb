module Forum::TopicsHelper
    def topic_link(topic)
        link_to topic, forum_category_forum_topic_path(topic.forum.category, topic.forum, topic)
    end
end
