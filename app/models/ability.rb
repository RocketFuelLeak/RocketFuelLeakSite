class Ability
    include CanCan::Ability

    def initialize(user)
        unless user
            can :read, [Post, Addon]
        else
            if user.is_admin?
                can :manage, :all
            elsif user.is_officer?
                can [:read, :create], Post
                can :edit, Post, user: user
            else
                can :read, :mumble
            end
        end
    end
end
