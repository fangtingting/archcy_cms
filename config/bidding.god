rails_env = ENV['RAILS_ENV'] || 'production'
rails_root = ENV['RAILS_ROOT'] || '/var/www/in4'
puts "#{rails_env}----#{rails_root}"
God.pid_file_directory = "#{rails_root}/tmp/pids"

# ------------------------------------------监控unicorn------------------------------------------
unicorn_pid_file = "#{rails_root}/tmp/pids/unicorn.pid"
God.watch do |w|
  w.name = "unicorn"
  w.dir = rails_root
  w.interval = 30.seconds
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = unicorn_pid_file
  w.behavior(:clean_pid_file)
  w.log = File.join(rails_root, 'log/god_unicorn.log')

  w.start = "cd #{rails_root} && unicorn -c #{rails_root}/config/unicorn.rb -E #{rails_env} -D"
  w.stop = "kill -QUIT `cat #{unicorn_pid_file}`"
  w.restart = "kill -USR2 `cat #{unicorn_pid_file}`"

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end

  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 500.megabytes
      c.times = [3, 5] # 3 out of 5 intervals
    end

    restart.condition(:cpu_usage) do |c|
      c.above = 80.percent
      c.times = 5
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end

# ------------------------------------------监控sidekiq------------------------------------------
sidekiq_pid_file = "#{rails_root}/tmp/pids/sidekiq.pid"
God.watch do |w|
  w.name = "sidekiq"
  w.dir = rails_root
  w.interval = 20.seconds
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = sidekiq_pid_file
  w.behavior(:clean_pid_file)
  w.log = File.join(rails_root, 'log/god_sidekiq.log')

  w.start = "bundle exec sidekiq -d -e production -P #{sidekiq_pid_file} -L log/sidekiq.log"
  w.stop = "kill -QUIT `cat #{sidekiq_pid_file}`"
  # w.stop = "bundle exec sidekiqctl stop #{sidekiq_pid_file} 5"

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end

  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 4000.megabytes
      c.times = [8, 10] # 3 out of 5 intervals
    end

    restart.condition(:cpu_usage) do |c|
      c.above = 150.percent
      c.times = 10
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end

# ------------------------------------------监控四个监听------------------------------------------
# reach_start和it_msg_start，详见DataSyncListener文件
# redis_start，详见RedisListener文件
# rcc_org_auth_start，详见RccOrgAuth::SyncDataWorker文件

["reach", "it_msg", "redis", "rcc_org_auth"].each do |type|
  God.watch do |w|
    w.name = "listener_#{type}"
    w.dir = rails_root
    w.interval = 30.seconds
    w.start_grace = 5.seconds
    w.restart_grace = 5.seconds
    w.pid_file = "#{rails_root}/tmp/pids/listener_#{type}.pid"
    w.behavior(:clean_pid_file)
    w.log = "#{rails_root}/log/god_#{type}.log"

    w.start = "cd #{rails_root} && RAILS_ENV=production rake listener:#{type}_start"
    w.stop = "kill -QUIT `cat #{rails_root}/tmp/pids/listener_#{type}.pid`"

    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 5.seconds
        c.running = false
      end
    end

    w.restart_if do |restart|
      restart.condition(:memory_usage) do |c|
        c.above = 500.megabytes
        c.times = [3, 5] # 3 out of 5 intervals
      end

      restart.condition(:cpu_usage) do |c|
        c.above = 80.percent
        c.times = 5
      end
    end

    # lifecycle
    w.lifecycle do |on|
      on.condition(:flapping) do |c|
        c.to_state = [:start, :restart]
        c.times = 5
        c.within = 5.minute
        c.transition = :unmonitored
        c.retry_in = 10.minutes
        c.retry_times = 5
        c.retry_within = 2.hours
      end
    end
  end
end