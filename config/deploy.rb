default_run_options[:pty] = true
set :repository,  'git@github.com:port49/aquaprgroup.com.git'

set :scm, :git
set :ssh_options, {:forward_agent => true}

set :runner, 'aqua'
set :branch, 'master'
set :deploy_via, :remote_cache

set :application, "aqua"
set :deploy_to, "/home/aqua/www"

role :app, "aqua"
role :web, "aqua"
role :db,  "aqua", :primary => true

namespace :passenger do
  desc 'Restart Application'
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :deploy do
  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Overrides the default because of the rake location"
  task :seed do
    run "cd #{current_path}; rake RAILS_ENV=production db:seed"
  end

  desc "Link in the production database.yml" 
  task :after_update_code do
    run "ln -nfs #{deploy_to}/#{shared_dir}/system/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/system/uploads #{release_path}/public/system"
  end
end

after :deploy, 'deploy:cleanup'
