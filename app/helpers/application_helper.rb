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
        renderer = HTMLWithPygments.new(hard_wrap: true, filter_html: true)
        options = {
            autolink: true,
            no_intra_emphasis: true,
            fenced_code_blocks: true,
            lax_html_blocks: true,
            strikethrough: true,
            superscript: true
        }
        Redcarpet::Markdown.new(renderer, options).render(text).html_safe
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
end
