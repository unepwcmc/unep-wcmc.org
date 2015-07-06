# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'unepwcmc-cap3'
set :repo_url, 'git@github.com:unepwcmc/unep-wcmc.org'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp


set :deploy_user, 'wcmc'


# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:application)}"

# Default value for :scm is :git
set :scm, :git
set :scm_username, "unepwcmc-read"


set :rvm_ruby_string, '2.0.0-p451'
set :rvm_type, :user




set :ssh_options, {
  forward_agent: true,
}


# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
#set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

set :linked_files, %w{config/database.yml config/mailer_config.yml config/max_mind.yml}



namespace :db do
  task :setup do
    the_host = Capistrano::CLI.ui.ask("Database IP address: ")
    database_name = Capistrano::CLI.ui.ask("Database name: ")
    database_user = Capistrano::CLI.ui.ask("Database username: ")
    pg_password = Capistrano::CLI.password_prompt("Database user password: ")

    require 'yaml'

    spec = {
      "#{rails_env}" => {
        "adapter" => "postgresql",
        "database" => database_name,
        "username" => database_user,
        "host" => the_host,
        "password" => pg_password
      }
    }

    run "mkdir -p #{shared_path}/config"
    put(spec.to_yaml, "#{shared_path}/config/database.yml")
  end
end

namespace :mailer do
  task :setup do
    smtp_user = Capistrano::CLI.ui.ask("SMTP username: ")
    smtp_password = Capistrano::CLI.password_prompt("SMTP password: ")

    require 'yaml'

    spec = {
      "user_name" => smtp_user,
      "password" => smtp_password
    }

    run "mkdir -p #{shared_path}/config"
    put(spec.to_yaml, "#{shared_path}/config/mailer_config.yml")
  end
end

after "deploy:setup", 'db:setup'
after "deploy:setup", 'mailer:setup'





# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do


  desc "Restart app"
  task: restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :finishing, "deploy:cleanup"

end


