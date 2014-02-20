class Ability
    include CanCan::Ability

    def initialize(user)
        user ||= User.new

        if user.has_role? :admin
            can :manage, :all
        elsif user.has_role? :officer
            can [:read, :create], Post
            can :edit, Post, user: user
        else
            can :read, Post
            can :read, Addon
            can :read, User
        end
    end
end
