module ApplicationHelper
    class HTMLWithPygments < Redcarpet::Render::HTML
        def block_code(code, language)
            sha = Digest::SHA1.hexdigest(code)
            Rails.cache.fetch ["code", language, sha].join('-') do
                Pygments.highlight(code, lexer: language)
            end
        end
    end

    def markdown(text)
        renderer = HTMLWithPygments.new(hard_wrap: true, filter_html: true, with_toc_data: true)
        options = {
            autolink: true,
            no_intra_emphasis: true,
            fenced_code_blocks: true,
            tables: true,
            lax_html_blocks: true,
            strikethrough: true,
            space_after_headers: true,
            superscript: true,
            underline: true,
            quote: true
        }
        Redcarpet::Markdown.new(renderer, options).render(text).html_safe
    end

    def markdown_with_youtube(text)
        markdown(text).gsub(/<a.+href="https?:\/\/[^y]*youtube\.[^\/]+\/watch\?[^v]*v=([A-Za-z0-9\-_]+).*<\/a>/,
            "<div class=\"flex-video widescreen\"><iframe src=\"https://www.youtube.com/embed/\\1\" allowfullscreen=\"true\" frameborder=\"0\"></iframe></div>").html_safe
    end

    def flash_class(level)
        case level
            when :notice then "alert alert-info"
            when :success then "alert alert-success"
            when :error then "alert alert-danger"
            when :alert then "alert alert-danger"
        end
    end

    def time_ago_abbr(date)
        content_tag :abbr, "#{time_ago_in_words(date)} ago", title: date, data: { toggle: 'tooltip' }
    end

    def zero_pluralize(n, noun, empty, empty_pluralize = true)
        if n == 0
            "#{empty} #{empty_pluralize ? noun.pluralize : noun}"
        else
            pluralize(n, noun)
        end
    end

    def class_text(class_id)
        case class_id
        when Symbol
            class_id.to_s
        when Integer
            WoW::Constants::CLASS_IDS[class_id].to_s
        end
    end

    def class_link_class(class_id)
        "link-#{class_text(class_id)}"
    end

    def class_link(text, target, class_id)
        link_to text, target, class: class_link_class(class_id)
    end

    def class_span(class_id, content)
        css_class = "text-#{class_text(class_id)}"
        content_tag :span, content, class: css_class
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
