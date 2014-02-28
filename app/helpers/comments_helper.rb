module CommentsHelper
    def formatted_comment(content)
        markdown(content).gsub(/<h\d+.*?>/, '<p>').gsub(/<\/h\d+>/, '</p>').html_safe
    end
end
