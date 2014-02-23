atom_feed root_url: posts_url, language: 'en-US' do |feed|
    feed.title "Rocket Fuel Leak News"
    feed.updated(@updated) unless @posts.empty?

    @posts.each do |post|
        next if post.updated_at.blank?

        feed.entry post do |entry|
            entry.title post.title
            entry.content markdown(post.content), type: 'html'
            entry.author do |author|
                author.name post.user
            end
        end
    end
end
