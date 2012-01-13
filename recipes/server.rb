include_recipe "mysql::client"

directory "/var/cache/local/preseeding" do
  owner "root"
  group "root"
  mode 0755
  recursive true
end

execute "preseed mysql-server" do
  command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
  action :nothing
end

template "/var/cache/local/preseeding/mysql-server.seed" do
  source "mysql-server.seed.erb"
  owner "root"
  group "root"
  mode "0600"
  notifies :run, resources(:execute => "preseed mysql-server"), :immediately
end

package "mysql-server"

service "mysql" do
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

template "#{node['mysql']['confdir']}/my.cnf" do
  cookbook "mysql"
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "mysql")
end

template "/root/.my.cnf" do
  cookbook "mysql"
  source "user.my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :username => "root",
    :password => node.mysql.root_password
  )
end

bootstrap_profile "mysql" do
  username "root"
  params [
    "export MYSQL_ROOT_PASSWORD='#{node.mysql.root_password}'"
  ]
end

# Don't log to syslog
cookbook_file "#{node[:mysql][:confdir]}/conf.d/mysqld_safe_syslog.cnf" do
  cookbook "mysql"
  source "mysqld_safe_syslog.cnf"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "mysql")
end
