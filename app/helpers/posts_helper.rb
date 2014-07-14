module PostsHelper
    def title_content
        content_for?(:news_title) ? content_for(:news_title) : 'News'
    end

    def send_title
        title title_content unless content_for?(:title)
    end

    def feed_markdown(text)
        markdown_with_youtube(text).gsub(/<img /, '<img style="max-width: 565px; height: auto; display: block;" ').html_safe
    end
end
