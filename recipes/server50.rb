apt_repository "hardy-security" do
  uri "http://security.ubuntu.com/ubuntu"
  sources %w[deb deb-src]
  distributions %w[hardy-security]
  components %w[main]
end

include_recipe "mysql::client50"
gem "mysql"

package "debconf-utils"

execute "preseed mysql-server-5.0" do
  command %{
    echo mysql-server-5.0 mysql-server/root_password select #{node[:mysql][:root_password]} | debconf-set-selections
    echo mysql-server-5.0 mysql-server/root_password_again select #{node[:mysql][:root_password]} | debconf-set-selections
    echo mysql-server-5.0 mysql-server-5.0/start_on_boot boolean true | debconf-set-selections
  }
end
# Backwards compatible
file "/var/cache/local/preseeding/mysql-server-5.0.seed" do
  action :delete
end

package "mysql-server-5.0"

service "mysql" do
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

# MySQL 5.0 doesn't support those configs
node[:mysql].delete(:slow_query_log_file)
node[:mysql][:tunable].delete(:table_open_cache)

template "#{node['mysql']['confdir']}/my.cnf" do
  cookbook "mysql"
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "mysql"), :delayed
end

execute "clear mysql-server-5.0 root password preseed" do
  command %{
    echo mysql-server-5.0 mysql-server/root_password select | debconf-set-selections
    echo mysql-server-5.0 mysql-server/root_password_again select | debconf-set-selections
  }
end
