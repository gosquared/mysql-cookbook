mysql_database "*" do
  username "root"
  password node[:mysql][:root_password]
  action :generate_mycnf
end

bootstrap_profile "mysql" do
  username "root"
  params [
    "export MYSQL_ROOT_PASSWORD='#{node.mysql.root_password}'"
  ]
end
