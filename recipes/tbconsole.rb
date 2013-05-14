jruby_gem "torquebox-console"

execute "install tbconsole" do
  command "tbconsole deploy"
  creates "/opt/torquebox/jboss/standalone/deployments/torquebox-console-knob.yml"
end