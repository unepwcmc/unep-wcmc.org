# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}

set :stage, :staging
set :branch, :master


server "unep-wcmc-staging.linode.unep-wcmc.org", user: 'wcmc', roles: %w{app web db}

set :application, "unep-wcmc"
set :server_name, "unepwcmc.unep-wcmc-staging.linode.unep-wcmc.org"
set :sudo_user, "wcmc"
set :app_port, "80"



#desc "Configure VHost"
#task :config_vhost do
#  vhost_config =<<-EOF
#    server {
#      listen 80;
#      client_max_body_size 20M;
#      server_name #{application}.178.79.184.157;
#      keepalive_timeout 5;
#      root #{deploy_to}/current/public;
#      passenger_enabled on;
#      rails_env production;
#      passenger_ruby /home/wcmc/.rvm/gems/ruby-2.2.2/wrappers/ruby;
      
#      gzip on;
#      location ~ ^/assets/ {
#      root /home/wcmc/unepwcmc/current/public;
#      expires max;
#      add_header Cache-Control public;
#      add_header ETag "";
#      break;
# }
#    }
#  EOF
#
#  put vhost_config, "/tmp/vhost_config"
#  sudo "mv /tmp/vhost_config /etc/nginx/sites-available/#{application}"
#  sudo "ln -s /etc/nginx/sites-available/#{application} /etc/nginx/sites-enabled/#{application}"
#end

#after "deploy:setup", :config_vhost





# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }

