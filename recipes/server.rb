version = node[:torquebox][:version]
prefix  = "/opt/torquebox-#{version}"
current = "/opt/torquebox-current"

ENV['TORQUEBOX_HOME'] = current
ENV['JBOSS_HOME']     = "#{current}/jboss"
ENV['JRUBY_HOME']     = "#{current}/jruby"
ENV['PATH']           = "#{ENV['PATH']}:#{ENV['JRUBY_HOME']}/bin"

include_recipe 'iptables'
iptables_rule 'iptables'

package "unzip"
package "upstart"
package 'logrotate'

user "torquebox" do
  uid 502
  comment "torquebox"
  home "/home/torquebox"
  supports :manage_home => true
end

gem_package "ruby-shadow" do
  action :install
end

directory "/home/torquebox/.ssh" do
  owner "torquebox"
  group "torquebox"
  mode "0700"
end

install_from_release('torquebox') do
  release_url node[:torquebox][:url]
  home_dir prefix
  action [:install, :install_binaries]
  version version
  checksum node[:torquebox][:checksum]
  not_if { File.exists?(prefix) }
end

template "/etc/profile.d/torquebox.sh" do
  mode "755"
  source "torquebox.erb"
  notifies :restart, "service[torquebox]"
end

execute 'reload-sysctl' do
  command 'sysctl -p'
  action :nothing
end

# contains network tuning for jgroups
cookbook_file '/etc/sysctl.conf' do
  source 'sysctl.conf'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :run, 'execute[reload-sysctl]', :immediately
end

link current do
  to prefix
end

# install upstart & get it running
execute "torquebox-upstart" do
  command "jruby -S rake torquebox:upstart:install"
  creates "/etc/init/torquebox.conf"
  cwd current
  action :run
  environment ({
      'TORQUEBOX_HOME' => current,
      'JBOSS_HOME'     => "#{current}/jboss",
      'JRUBY_HOME'     => "#{current}jruby",
      'PATH'           => "#{ENV['PATH']}:#{current}/jruby/bin"
  })
end

execute "chown torquebox" do
  command "chown -R torquebox:torquebox /usr/local/share/torquebox-#{version}"
end

# centos does not properly handle some events during boot, so replace the
# upstart script with one that will work there.
if node['platform'] == 'centos'
  template '/etc/init/torquebox.conf' do
    source 'upstart.erb'
    owner 'root'
    group 'root'
    mode '0644'
  end
end

cookbook_file "/opt/torquebox-current/jruby/bin/restart_torquebox" do
  source "restart_torquebox"
  owner "root"
  group "root"
  mode 0755
end

service "torquebox" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
  restart_command "/opt/torquebox-current/jruby/bin/restart_torquebox"
end

#allows use of 'torquebox' command through sudo
cookbook_file "/etc/sudoers.d/torquebox" do
  source 'sudoers'
  owner 'root'
  group 'root'
  mode '0440'
end

cookbook_file '/etc/logrotate.d/torquebox' do
  source 'logrotate'
  owner 'root'
  group 'root'
end

directory node[:torquebox][:data_dir] do
  owner 'torquebox'
  group 'torquebox'
  recursive true
end

template "/opt/torquebox-current/jboss/bin/standalone.conf" do
  source 'standalone.conf.erb'
  owner 'torquebox'
  group 'torquebox'
  notifies :restart, 'service[torquebox]'
end

template "/opt/torquebox-current/jboss/standalone/configuration/standalone-ha.xml" do
  source "standalone-ha.xml.erb"
  owner 'torquebox'
  group 'torquebox'
  notifies :restart, 'service[torquebox]'
end

template "/opt/torquebox-current/jboss/standalone/configuration/standalone.xml" do
  source "standalone.xml.erb"
  owner 'torquebox'
  group 'torquebox'
  notifies :restart, 'service[torquebox]'
end
