module Forum::PostsHelper
    def post_link(text, post)
        link_to text, forum_category_forum_topic_post_path(post.topic.forum.category, post.topic.forum, post.topic, post)
    end
end
