maintainer       "Jorge Falcao"
maintainer_email "jlbfalcao@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures torquebox"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "2.3.0"

depends "java", ">= 1.8.0"
depends "install_from"
depends 'cron'
depends 'users'
depends 'jruby'
depends 'iptables'

supports "ubuntu"
supports "debian"
