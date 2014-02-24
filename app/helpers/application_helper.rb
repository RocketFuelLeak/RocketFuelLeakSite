module ApplicationHelper
    class HTMLWithPygments < Redcarpet::Render::HTML
        def block_code(code, language)
            sha = Digest::SHA1.hexdigest(code)
            Rails.cache.fetch ["code", language, sha].join('-') do
                Pygments.highlight(code, lexer: language)
            end
        end
    end

    def flash_class(level)
        case level
            when :notice then "alert alert-info"
            when :success then "alert alert-success"
            when :error then "alert alert-danger"
            when :alert then "alert alert-danger"
        end
    end

    def markdown(text)
        renderer = HTMLWithPygments.new(hard_wrap: true, filter_html: true, with_toc_data: true)
        options = {
            autolink: true,
            no_intra_emphasis: true,
            fenced_code_blocks: true,
            lax_html_blocks: true,
            strikethrough: true,
            superscript: true
        }
        html = Redcarpet::Markdown.new(renderer, options).render(text)
        html.gsub(/<a.+href="https?:\/\/[^y]*youtube\.[^\/]+\/watch\?[^v]*v=([A-Za-z0-9\-_]+).*<\/a>/,
                  "<div class=\"flex-video widescreen\"><iframe src=\"https://www.youtube.com/embed/$1\" allowfullscreen=\"true\" frameborder=\"0\"></iframe></div>").html_safe
    end

    def resource_name
        :user
    end

    def resource
        @resource ||= User.new
    end

    def devise_mapping
        @devise_mapping ||= Devise.mappings[:user]
    end

    def title(title)
        content_for :title, "RFL - #{title}"
    end

    def description(description)
        content_for :description, description
    end

    def keywords(keywords)
        content_for :keywords, keywords
    end
end
