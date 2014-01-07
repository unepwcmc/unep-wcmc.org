set :application, "unepwcmc"
set :repository, "git@github.com:unepwcmc/unep-wcmc.org"
set :deploy_via, :remote_cache
set :scm, :git
set :branch, "rails"

set :ssh_options, {forward_agent: true}

set :domain, "unep-wcmc.demo.llp.pl"
set :port, 20120
set :rails_env, "production"

role :web, domain
role :app, domain
role :db, domain, :primary => true

set :user, "unepwcmc"
set :use_sudo, false
set :deploy_to, "/home/app/unepwcmc"

set :keep_releases, 2

after "deploy:update_code", "db:symlink"
before "deploy:assets:precompile", "db:symlink"

namespace :db do
  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do
  task :start, roles: :app, except: { no_release: true } do
    run "cd #{current_path} && #{try_sudo} bundle exec unicorn -p 3000 -E #{rails_env} -D -P #{unicorn_pid}"
  end
  task :stop, roles: :app, except: { no_release: true } do
    run "#{try_sudo} kill `cat #{unicorn_pid}`"
  end
  task :restart, roles: :app, except: { no_release: true } do
    stop
    start
  end
end
