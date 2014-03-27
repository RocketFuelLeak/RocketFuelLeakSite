module Forum::ForumsHelper
    def forum_link(forum)
        link_to forum, forum_category_forum_path(forum.category, forum)
    end
end
