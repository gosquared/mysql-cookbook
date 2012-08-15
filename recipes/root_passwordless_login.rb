mysql_database "*" do
  username "root"
  password node[:mysql][:root_password]
  action :generate_mycnf
end
