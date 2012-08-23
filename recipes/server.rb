include_recipe "mysql::client"
gem "mysql"

package "debconf-utils"

execute "preseed mysql-server" do
  command %{
    echo mysql-server-5.1 mysql-server/root_password select #{node[:mysql][:root_password]} | debconf-set-selections
    echo mysql-server-5.1 mysql-server/root_password_again select #{node[:mysql][:root_password]} | debconf-set-selections
    echo mysql-server-5.1 mysql-server-5.1/start_on_boot boolean true | debconf-set-selections
  }
end
# Backwards compatible
file "/var/cache/local/preseeding/mysql-server.seed" do
  action :delete
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

# As of 5.1.20, MySQL can log to syslog
cookbook_file "#{node[:mysql][:confdir]}/conf.d/mysqld_log_to_syslog.cnf" do
  cookbook "mysql"
  owner "root"
  group "root"
  mode "0644"
  action (node[:mysql][:syslog] ? :create : :delete)
  notifies :restart, resources(:service => "mysql"), :delayed
end
# Backwards compatibility
file "#{node[:mysql][:confdir]}/conf.d/mysqld_safe_syslog.cnf" do
  action :delete
end

execute "clear mysql-server-5.1 root password preseed" do
  command %{
    echo mysql-server-5.1 mysql-server/root_password select | debconf-set-selections
    echo mysql-server-5.1 mysql-server/root_password_again select | debconf-set-selections
  }
end
