class Ability
    include CanCan::Ability

    def initialize(user)
        unless user
            can :read, [Post, Addon]
        else
            if user.is_admin?
                can :manage, :all
            elsif user.is_officer?
                can [:read, :read_drafts, :create], Post
                can [:update, :destroy], Post, user: user
                can [:read, :update], Addon
                can :read, [User, :mumble]
            else
                can :read, [Post, Addon, User, :mumble]
            end
        end
    end
end
