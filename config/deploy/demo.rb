set :stage, :demo

set :domain, 'unep-wcmc.demo.llp.pl'
set :port, 20021
set :rails_env, 'production'

role :app, domain
role :web, domain
role :db, domain

set :user, "unepwcmc"
set :use_sudo, "false"
set :deploy_to, "/home/app/unepwcmc"

set :keep_releases, 2
