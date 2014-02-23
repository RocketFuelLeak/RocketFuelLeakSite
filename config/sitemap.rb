# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://rocketfuelleak.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add epgp_path
  #add mumble_path # Mumble path is not accessible by the public
  add about_path
  add privacy_path
  add terms_path

  add addons_path
  Addon.find_each do |addon|
    add addon_path(addon), lastmod: addon.updated_at
  end

  add posts_path
  Post.find_each do |post|
    add post_path(post), lastmod: post.updated_at if post.published
  end
end
