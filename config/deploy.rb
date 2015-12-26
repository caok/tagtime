# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'tagtime'
set :repo_url, 'git@github.com:Techbay/tagtime.git'

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :deploy_user, 'deploy'
set :keep_releases, 5
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/tagtime"

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

set :scm, :git
set :bundle_without,  %w{development test}.join(' ')
set :linked_files, fetch(:linked_files, []).push('config/application.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :use_sudo, false
set :rails_env, 'production'
set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH", RBENV_VERSION: "2.2.0" }
set :rbenv_path, '/home/deploy/.rbenv/'
set :rbenv_ruby, '2.2.0'
set :depoly_via, :remote_cache
set :backup_path, "/home/#{fetch(:deploy_user)}/Backup"
set :conditionally_migrate, true

# for unicorn
set :unicorn_config_path, -> { File.join(current_path, "config", "unicorn.rb") }

# for assets
set :keep_assets, 2

namespace :deploy do
  desc "Init the config files in shared_path"
  task :setup_config do
    on roles(:all), in: :sequence, wait: 5 do
      unless test "[ -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
        upload!("config/application.example.yml", "#{shared_path}/config/application.yml")
        puts "Now edit the config files in #{shared_path}"
      end
    end
  end
  after "check:directories", :setup_config

  # for unicorn operate
  desc "Start Application"
  task :start do
    on roles(:all), in: :sequence, wait: 5 do
      within current_path do
        execute :bundle, "exec unicorn_rails", "-c", fetch(:unicorn_config_path), "-E production -D"
      end
    end
  end

  desc "Stop Application"
  task :stop do
    on roles(:all), in: :sequence, wait: 5 do
      execute "kill -QUIT `cat #{shared_path}/tmp/pids/unicorn.#{fetch(:application)}.pid`"
    end
  end

  desc "Restart Application"
  task :restart do
    on roles(:all), in: :sequence, wait: 10 do
      execute "kill -USR2 `cat #{shared_path}/tmp/pids/unicorn.#{fetch(:application)}.pid`"
    end
  end

  desc "Start or Restart Application"
  task :start_or_restart do
    on roles(:web), in: :sequence, wait: 10 do
      if test "[ -f #{shared_path}/tmp/pids/unicorn.#{fetch(:application)}.pid ]"
        execute "kill -USR2 `cat #{shared_path}/tmp/pids/unicorn.#{fetch(:application)}.pid`"
      else
        within current_path do
          execute :bundle, "exec unicorn_rails", "-c", fetch(:unicorn_config_path), "-E production -D"
        end
      end
      execute "rm -rf tmp/cache"
    end
  end

  after :publishing, :start_or_restart
  after :finishing, :cleanup
end
