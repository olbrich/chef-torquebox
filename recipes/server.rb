

version = node[:torquebox][:version]
prefix = "/opt/torquebox-#{version}"
current = "/opt/torquebox-current"

package "unzip"
package "upstart"

user "torquebox" do
  comment "torquebox"
  #shell "/bin/false"
  home "/home/torquebox"
  supports :manage_home => true
end

install_from_release('torquebox') do
  release_url   node[:torquebox][:url]
  home_dir      prefix
  action        [:install, :install_binaries]
  version       version
  checksum      node[:torquebox][:checksum]
  not_if{ File.exists?(prefix) }
end

template "/etc/profile.d/torquebox.sh" do
  mode "755"
  source "torquebox.erb"
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
    'TORQUEBOX_HOME'=> current,
    'JBOSS_HOME'=> "#{current}/jboss",
    'JRUBY_HOME'=> "#{current}jruby",
    'PATH' => "#{ENV['PATH']}:#{current}/jruby/bin"
  })
end

execute "chown torquebox" do
    command "chown -R torquebox:torquebox /usr/local/share/torquebox-#{version}"
end

service "torquebox" do
    provider Chef::Provider::Service::Upstart
    action [:enable, :start]
end

# otherwise bundler won't work in jruby
gem_package 'jruby-openssl' do
    gem_binary "#{current}/jruby/bin/jgem"
end