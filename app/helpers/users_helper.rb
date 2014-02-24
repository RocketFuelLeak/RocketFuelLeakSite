module UsersHelper
    def role_button_class(role)
        case role
        when :admin
            "btn-danger"
        when :officer
            "btn-success"
        else
            "btn-default"
        end
    end
end
