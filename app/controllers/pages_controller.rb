require 'redis'
require 'json'

class PagesController < ApplicationController
    def index
        @posts = Post.recently_published.limit(5)
        data = REDIS.get "wowprogress"
        @wowprogress = JSON.parse(data) if data
        if @wowprogress
            @score = @wowprogress["score"]
            @world_rank = @wowprogress["world_rank"]
            @region_rank = @wowprogress["area_rank"]
            @realm_rank = @wowprogress["realm_rank"]
            @ranks_fetched_at = @wowprogress["fetched_at"]
        end
        @roster = User.includes(:character)
                      .with_any_role(:raider, :trial)
                      .map { |user| {status: user.has_role?(:trial) ? 'Trial' : 'Raider', character: user.character} }
                      .sort do |a, b|
                        (a[:status] <=> b[:status]).nonzero? ||
                        (b[:character].role <=> a[:character].role).nonzero? ||
                        (a[:character].name <=> b[:character].name)
                      end
    end

    def rules
    end

    def mumble
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
