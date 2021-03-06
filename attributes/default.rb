default[:torquebox][:version]      = "2.3.2"
default[:torquebox][:url]          = "http://torquebox.org/release/org/torquebox/torquebox-dist/#{node[:torquebox][:version]}/torquebox-dist-#{node[:torquebox][:version]}-bin.zip"
default[:torquebox][:checksum]     = "b30ecaac1c1b8b42d8b3aba4fb2335d2054f21a3"
default[:torquebox][:jruby][:opts] = "--1.9 -Xcext.enabled=true"
override[:jruby][:install_path]     = "/opt/torquebox-current/jruby"
default[:torquebox][:data_dir]     = "/var/torquebox/data"
default[:torquebox][:bind_address] = "0.0.0.0"

default[:torquebox][:backstage_secured] = true

# delay in milliseconds
default[:hornetq][:redelivery_delay] = 10_000
override[:hornetq][:max_delivery_attempts] = 10
#default[:java][:opts] = "-Xms3072m -Xmx3072m"
default[:ulimit][:filehandle_limit] = 100_000

# uncomment or override this attribute on a node or in another role/cookbook to run clustered
#default[:torquebox][:server_opts] = "--server-config=standalone-ha.xml -b=#{node[:ipaddress]}"
