require "rvm/capistrano"
require "bundler/capistrano"



set :application, "unepwcmc"
set :repository, "git@github.com:unepwcmc/unep-wcmc.org"
set :deploy_via, :remote_cache
set :scm, :git
set :branch, "master"
set :scm_username, "unepwcmc-read"

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :domain, "ec2-54-195-244-198.eu-west-1.compute.amazonaws.com"
set :rails_env, "production"

server "ec2-54-195-244-198.eu-west-1.compute.amazonaws.com", :app, :web, :db, :primary => true

set :user, "ubuntu"
set :use_sudo, false
set :deploy_to, "/home/ubuntu/unepwcmc"

set :keep_releases, 2

after "deploy:update_code", "db:symlink"
before "deploy:assets:precompile", "db:symlink"
after "deploy:restart", "deploy:cleanup"

namespace :db do
  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/mailer_config.yml #{release_path}/config/mailer_config.yml"
    run "ln -nfs #{shared_path}/config/max_mind.yml #{release_path}/config/max_mind.yml"
  end
end

# set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

#namespace :deploy do
#  task :start, roles: :app, except: { no_release: true } do
#    run "cd #{current_path} && #{try_sudo} bundle exec unicorn -p 3000 -E #{rails_env} -D -P #{unicorn_pid}"
#  end
#  task :stop, roles: :app, except: { no_release: true } do
#    run "#{try_sudo} kill `cat #{unicorn_pid}`"
#  end
#  task :restart, roles: :app, except: { no_release: true } do
#    stop
#    start
#  end
#end


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

######################## CAPISTRANO / SLACK INTEGRATION #######################################
require 'capistrano/slack'
#required
require 'yaml'
set :secrets, YAML.load(File.open('config/secrets.yml'))

set :slack_token, secrets["development"]["capistrano_slack"] # comes from inbound webhook integration
set :slack_room, "#unep-wcmc-website" # the room to send the message to
set :slack_subdomain, "wcmc" # if your subdomain is example.slack.com

# optional
set :slack_application, "UNEP-WCMC Website" # override Capistrano `application`
deployment_animals = [
  ["Loxodonta deployana", ":elephant:"],
  ["Canis deployus", ":wolf:"],
  ["Panthera capistranis", ":tiger:"],
  ["Bison deployon", ":ox:"],
  ["Ursus capistranus", ":bear:"],
  ["Crotalus rattledeploy", ":snake:"],
  ["Caiman assetocompilatus", ":crocodile:"]
]

set :shuffle_deployer, deployment_animals.shuffle.first

set :slack_username, shuffle_deployer[0] # displayed as name of message sender
set :slack_emoji, shuffle_deployer[1] # will be used as the avatar for the message

######################## /EO CAPISTRANO / SLACK INTEGRATION #######################################
