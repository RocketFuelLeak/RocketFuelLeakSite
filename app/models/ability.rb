class Ability
    include CanCan::Ability

    def initialize(user)
        alias_action :connection, to: :connect
        alias_action :confirmation, to: :confirm

        # Note: 'archive' is to READ archives
        if not user
            can :read, [Post, Addon, :mumble]
            can :archive, Post
            can :read, Comment, commentable_type: 'Post'
        else
            if user.is_admin?
                can :manage, :all
                return # No need to continue, or?
            end

            can :read, [Post, Addon, User, Character, :mumble]
            can :archive, Post
            can [:update, :destroy], Comment, user_id: user.id

            if user.is_member?
                can [:read, :create], Comment do |comment|
                    %w[Post Application].include? comment.commentable_type
                end

                can :read, Application
            else
                can [:read, :create], Comment do |comment|
                    comment.commentable_type == 'Post' or
                    (comment.commentable_type == 'Application' and comment.commentable.user_id == user.id)
                end

                can :connect, Character
                can :connect, User, id: user.id

                can :confirm, Character, user_id: user.id unless user.character.present? and user.character.confirmed

                can [:read, :destroy], Application, user_id: user.id
                can :create, Application
                can :update, Application, { user_id: user.id, status: Application::STATUS_IDS[:open] }
            end

            if user.is_officer?
                can [:read_drafts, :create], Post
                can [:update, :destroy], Post, user_id: user.id
                can :update, Addon

                can [:read, :create, :destroy], Comment do |comment|
                    %w[Post Application].include? comment.commentable_type
                end

                can [:accept, :decline], Application
            end
        end
    end
end
