module ApplicationsHelper
    STATUS_CLASSES = {
        open: 'default',
        accepted: 'success',
        declined: 'danger'
    }

    def status_class(status)
        case status
        when Symbol
            STATUS_CLASSES[status]
        when Integer
            status_class(Application::STATUS_TYPES[status])
        end
    end

    def status_label_class(status)
        "label-#{status_class(status)}"
    end

    def status_text(status)
        case status
        when Symbol
            status.to_s.titleize
        when Integer
            status_text(Application::STATUS_TYPES[status])
        end
    end

    def formatted_application(content)
        markdown_with_youtube(content).gsub(/<h[123].*?>/, '<p>').gsub(/<\/h[123]>/, '</p>').html_safe
    end

    def can_apply?
        return false unless user_signed_in?
        return false if current_user.character.present? and current_user.character.guild == WoW.guild
        return false if current_user.application.present?
        true
    end
end
