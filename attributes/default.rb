

default[:torquebox][:version] = "2.0.0.cr1"
default[:torquebox][:url] = "http://torquebox.org/release/org/torquebox/torquebox-dist/#{node[:torquebox][:version]}/torquebox-dist-#{node[:torquebox][:version]}-bin.zip"
default[:torquebox][:checksum] = "0f3a4c8fb66203fef7079172621ab502"
default[:torquebox][:jruby][:opts] = "--1.8"
default[:torquebox][:backstage_gitrepo] = "git://github.com/torquebox/backstage.git"
default[:torquebox][:backstage_home] = "/var/www/backstage"
