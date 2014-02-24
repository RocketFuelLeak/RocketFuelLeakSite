class Ability
    include CanCan::Ability

    def initialize(user)
        unless user
            can :read, [Post, Addon]
            can :archive, Post
        else
            if user.is_admin?
                can :manage, :all
            elsif user.is_officer?
                can [:read, :read_drafts, :archive, :create], Post
                can [:update, :destroy], Post, user: user
                can [:read, :update], Addon
                can :read, [User, :mumble]
            elsif user.is_member?
                can :read, [Post, Addon, User, :mumble]
                can :archive, Post
            else
                can :read, [Post, Addon, User]
                can :archive, Post
            end
        end
    end
end
