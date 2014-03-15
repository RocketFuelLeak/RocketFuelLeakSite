set :whenever_roles, ->{ :app }

set :stage, :production
set :rails_env, 'production'

server 'rocketfuelleak.com', user: 'rails', roles: %w{web app db},
    ssh_options: {
        port: 2553
    }

namespace :deploy do
    task :refresh_sitemaps do
        on roles(:app) do
            env_rake 'sitemap:refresh'
        end
    end

    after :deploy, :update_members
    after :deploy, :update_rankings
end

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options
