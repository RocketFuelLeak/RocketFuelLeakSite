# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://rocketfuelleak.com"

SitemapGenerator::Sitemap.create do
  add rules_path
  add epgp_path
  add mumble_path
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
