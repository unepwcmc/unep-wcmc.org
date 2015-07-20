set :sudo_u0ser, "wcmc"

namespace :config do
  task :setup do
    ask(:db_user, 'db_user')
    ask(:db_pass, 'db_pass')
    ask(:db_name, 'db_name')
    ask(:db_host, 'db_host')
    setup_config = <<-EOF
#{fetch(:rails_env)}:
  adapter: postgresql
  database: #{fetch(:db_name)}
  username: #{fetch(:db_user)}
  password: #{fetch(:db_pass)}
  host: #{fetch(:db_host)}
    EOF

    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(setup_config), "#{shared_path}/config/database.yml"
    end
  end
end

namespace :config do
  task :setup do
    ask(:smtp_user, 'smtp_user')
    ask(:smtp_password, 'smtp_password')
    setup_config = <<-EOF
    user_name: #{fetch(:smtp_user)}
    password: #{fetch(:smtp_password)}
    EOF

    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(setup_config), "#{shared_path}/config/mailer_config.yml"
    end
  end
end



namespace :config do
task :setup do
 vhost_config = <<-EOF
  server {
    listen 80;
    server_name #{fetch(:application)}.178.79.184.157;
    passenger_enabled on;
    root #{deploy_to}/current/public;
    rails_env #{fetch(:rails_env)};
    client_max_body_size 20M;
    passenger_ruby /home/wcmc/.rvm/gems/ruby-2.0.0-p451/wrappers/ruby;
    gzip on;
    location ~ ^/assets/ {
    root #{deploy_to}/current/public;
    expires max;
    add_header Cache-Control public;
    add_header ETag "";
    break;
  }
}
EOF

    on roles(:app) do
      execute "sudo mkdir -p /etc/nginx/sites-available"
      upload! StringIO.new(vhost_config), "/tmp/vhost_config"
      execute "sudo mv /tmp/vhost_config /etc/nginx/sites-available/#{fetch(:application)}"
      execute "sudo ln -s /etc/nginx/sites-available/#{fetch(:application)} /etc/nginx/sites-enabled/#{fetch(:application)}"
    end
  end
end

