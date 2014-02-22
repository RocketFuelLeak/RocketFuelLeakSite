class PagesController < ApplicationController
    def index
        @posts = Post.recently_published.limit(5)
    end

    def mumble
        authorize! :read, :mumble
    end

    def epgp
    end

    def about
    end

    def privacy
    end

    def terms
    end
end
