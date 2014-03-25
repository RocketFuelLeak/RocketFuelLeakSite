class Forum::PagesController < ForumController
    def index
        @categories = Forum::Category.includes(:forums).ordered
    end
end
