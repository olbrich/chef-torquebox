jruby_gem 'torquebox-backstage'

backstage = data_bag_item(:backstage,'credentials')

# required to be writeable by torquebox for deploy to work right
file '/opt/torquebox/jruby/lib/ruby/gems/shared/gems/torquebox-backstage-1.0.7/Gemfile.lock' do
  owner 'torquebox'
  group 'torquebox'
  action :create_if_missing
end

execute 'deploy backstage' do
  if node[:torquebox][:backstage_secured]
    command "jruby -S backstage deploy --secure=#{backstage[node.chef_environment]['username']}:#{backstage[node.chef_environment]['password']}"
  else
    command "jruby -S backstage deploy"
  end
  creates "/opt/torquebox-current/jboss/standalone/deployments/torquebox-backstage-knob.yml"
end

