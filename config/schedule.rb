set :output, "#{path}/log/cron.log"

# 3 hours after scheduled end of raid every day
every :day, at: '03:00', roles: [:app] do
    rake "wowprogress:update_rankings"
end

every :day, at: '06:00', roles: [:app] do
    rake "wow:update_members"
end

every :day, at: '07:00', roles: [:app] do
    rake "sitemap:refresh"
end
