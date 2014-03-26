class ForumController < ApplicationController
    layout 'forum'

    before_action :load_latest_topics

    private
    def load_latest_topics
        @latest_topics = Forum::Topic.latest
    end
end
