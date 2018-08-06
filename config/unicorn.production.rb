worker_processes 2
listen 11080
timeout 30
pid 'tmp/pids/unicorn.production.pid'
stderr_path 'log/unicorn_production_stderr.log'
stdout_path 'log/unicorn_production_stdout.log'

preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # do something...
    end
  end
end

# 再起動失敗対策
# https://qiita.com/zaru/items/ddbb0c029d6c5760dc54
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = ENV['BUNDLE_GEMFILE_FOR_PRODUCTION']
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
