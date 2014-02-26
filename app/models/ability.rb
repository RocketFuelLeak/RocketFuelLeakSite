class Ability
    include CanCan::Ability

    def initialize(user)
        unless user
            can :read, [Post, Addon, :mumble]
            can :archive, Post
        else
            if user.is_admin?
                can :manage, :all
            elsif user.is_officer?
                can [:read, :read_drafts, :archive, :create], Post
                can [:update, :destroy], Post, user: user
                can [:read, :update], Addon
                can :read, [User, :mumble]
                can :read, Character
            elsif user.is_member?
                can :read, [Post, Addon, User, :mumble]
                can :archive, Post
                can :read, Character
            else
                can :read, [Post, Addon, User, Character, :mumble]
                can :archive, Post

                unless user.character.present?
                    can :connect, Character
                    can [:connect, :connection], Character
                    can :connect, User, id: user.id
                end

                can [:confirm, :confirmation], Character, user: user unless user.character.present? and user.character.confirmed
            end
        end
    end
end
