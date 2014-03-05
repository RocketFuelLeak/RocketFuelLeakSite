module PostsHelper
    def title_content
        content_for?(:news_title) ? content_for(:news_title) : 'News'
    end

    def send_title
        title title_content unless content_for?(:title)
    end
end
