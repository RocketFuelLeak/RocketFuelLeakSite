APP_NAME = "RocketFuelLeakSite"
APP_PATH = "/home/rails/apps/#{APP_NAME}"
APP_CURRENT = "#{APP_PATH}/current"
working_directory APP_CURRENT
pid "#{APP_CURRENT}/tmp/pids/unicorn.pid"
stdout_path "#{APP_PATH}/shared/log/unicorn.log"
stderr_path "#{APP_PATH}/shared/log/unicorn.err.log"

listen "/tmp/unicorn.#{APP_NAME}.sock"
worker_processes 2
timeout 30

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
    GC.copy_on_write_friendly = true

check_client_connection false

# Force the bundler gemfile environment variable to
# reference the capistrano "current" symlink
before_exec do |_|
  ENV["BUNDLE_GEMFILE"] = File.join(APP_CURRENT, 'Gemfile')
end

before_fork do |server, worker|
    server.logger.info("worker=#{worker.nr} spawning in #{Dir.pwd}")

    defined?(ActiveRecord::Base) and
        ActiveRecord::Base.connection.disconnect!

    # graceful shutdown of old master process
    old_pid_file = "#{server.pid}.oldbin"
    server.logger.info("checking old master process pid in #{old_pid_file}")
    if File.exists?(old_pid_file) && server.pid != old_pid_file
        begin
            old_pid = File.read(old_pid_file).to_i
            server.logger.info("sending QUIT to #{old_pid}")
            Process.kill("QUIT", old_pid)
        rescue Errno::ENOENT, Errno::ESRCH
            # someone else did our job for us
        end
    else
        server.logger.info("old master process not found")
    end
end

after_fork do |server, worker|
    defined?(ActiveRecord::Base) and
        ActiveRecord::Base.establish_connection
end
