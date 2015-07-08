# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'unepwcmc-cap3'
set :repo_url, 'git@github.com:unepwcmc/unep-wcmc.org'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp


set :deploy_user, 'wcmc'


set :backup_path, "/home/#{fetch(:deploy_user)}/Backup"



# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:application)}"

# Default value for :scm is :git
set :scm, :git
set :scm_username, "unepwcmc-read"


set :rvm_type, :user
set :rvm_ruby_version, '2.0.0-p451'



set :ssh_options, {
  forward_agent: true,
}


# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
#set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
#set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')


set :linked_files, %w{config/database.yml config/mailer_config.yml config/max_mind.yml}



# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

set :linked_dirs, %w{log public/system}





# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do


  desc "Restart app"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :finishing, "deploy:cleanup"

end


