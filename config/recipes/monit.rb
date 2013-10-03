namespace :monit do

  desc 'Setup all Monit configuration'
  task :setup do
    unicorn
    syntax
    reload
  end
  after 'deploy:setup', 'monit:setup'

  task(:unicorn, roles: :app) do
    monit_config 'unicorn', "/etc/monit/conf.d/#{application}_unicorn"
  end

  %w[start stop restart syntax reload].each do |command|
    desc 'Run Monit #{command} script'
    task command do
      run "#{sudo} service monit #{command}"
    end
  end
end

def monit_config(name, destination = nil)
  destination ||= "/etc/monit/conf.d/#{name}.conf"
  template "monit/#{name}.erb", "/tmp/monit_#{name}"
  run "#{sudo} mv /tmp/monit_#{name} #{destination}"
  run "#{sudo} chown root #{destination}"
  run "#{sudo} chmod 600 #{destination}"
end
