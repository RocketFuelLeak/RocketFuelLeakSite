module Forum::CategoriesHelper
    def category_link(category)
        link_to category, forum_category_path(category)
    end
end
