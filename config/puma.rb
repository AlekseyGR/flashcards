workers Integer(ENV['PUMA_WORKERS'] || 0)
threads Integer(ENV['PUMA_MIN_THREADS'] || 1), Integer(ENV['PUMA_MAX_THREADS'] || 4)

rackup DefaultRackup
port ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'
quiet

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

preload_app!
