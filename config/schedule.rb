set :output, "#{path}/log/cron.log"

every :day, at: '07:00', roles: [:app] do
    rake "sitemap:refresh"
end
