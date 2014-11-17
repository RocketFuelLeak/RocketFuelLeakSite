class Ability
    include CanCan::Ability

    def initialize(user)
        alias_action :post_connect, to: :connect
        alias_action :patch_confirm, to: :confirm

        # Note: 'archive' is to READ archives
        if not user
            can :read, [Post, Addon]
            can [:feed, :archive], Post
            can :read, Comment, commentable_type: 'Post'
            can :read, Forum::Category, access: Forum::Category::ACCESS_IDS[:everyone]
            can :read, Forum::Forum, read_access: Forum::Forum::ACCESS_IDS[:everyone], category: { access: Forum::Forum::ACCESS_IDS[:everyone] }
            can :read, Forum::Topic, forum: { read_access: Forum::Forum::ACCESS_IDS[:everyone] }
            can :read, Forum::Post, topic: { forum: { read_access: Forum::Forum::ACCESS_IDS[:everyone] } }
        else
            if user.is_admin?
                can :manage, :all
                return # No need to continue, or?
            end

            can :read, [Post, Addon, User, Character]
            can [:feed, :archive], Post
            can [:update, :destroy], Comment, user_id: user.id

            can [:update, :destroy], [Forum::Topic, Forum::Post], user_id: user.id

            if user.is_member?
                can [:read, :create], Comment do |comment|
                    %w[Post Application].include? comment.commentable_type
                end

                can [:read, :create], Application
                can :destroy, Application, user_id: user.id
                can :update, Application, { user_id: user.id, status: Application::STATUS_IDS[:open] }

                can :read, [Forum::Category, Forum::Forum]
                can [:read, :create], [Forum::Topic, Forum::Post]

                unless user.is_officer?
                    cannot :read,   Forum::Category, access:                            Forum::Category::ACCESS_IDS[:officers]
                    cannot :read,   Forum::Forum,    category: { access:                Forum::Category::ACCESS_IDS[:officers] }
                    cannot :read,   Forum::Forum,    read_access:                       Forum::Forum::ACCESS_IDS[:officers]
                    cannot :read,   Forum::Topic,    forum:    { read_access:           Forum::Forum::ACCESS_IDS[:officers] }
                    cannot :create, Forum::Topic,    forum:    { write_access:          Forum::Forum::ACCESS_IDS[:officers] }
                    cannot :read,   Forum::Post,     topic:    { forum: { read_access:  Forum::Forum::ACCESS_IDS[:officers] } }
                    cannot :create, Forum::Post,     topic:    { forum: { write_access: Forum::Forum::ACCESS_IDS[:officers] } }
                end
            else
                can [:read, :create], Comment do |comment|
                    comment.commentable_type == 'Post' or
                    (comment.commentable_type == 'Application' and comment.commentable.user_id == user.id)
                end

                can :connect, Character
                can :connect, User, id: user.id

                can :confirm, Character, user_id: user.id unless user.confirmed_character?

                can [:read, :destroy], Application, user_id: user.id
                can :create, Application
                can :update, Application, { user_id: user.id, status: Application::STATUS_IDS[:open] }

                can :read, Forum::Category, access: Forum::Category::ACCESS_IDS[:everyone]
                can :read, Forum::Forum, read_access: Forum::Forum::ACCESS_IDS[:everyone], category: { access: Forum::Forum::ACCESS_IDS[:everyone] }
                can :read, Forum::Topic, forum: { read_access: Forum::Forum::ACCESS_IDS[:everyone] }
                can :create, Forum::Topic, forum: { write_access: Forum::Forum::ACCESS_IDS[:everyone] }
                can :read, Forum::Post, topic: { forum: { read_access: Forum::Forum::ACCESS_IDS[:everyone] } }
                can :create, Forum::Post, topic: { forum: { write_access: Forum::Forum::ACCESS_IDS[:everyone] } }
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
