node[:mysql][:users].each do |user, properties|
  # Create user with privileges for specific dbs
  #
  hosts = properties[:hosts] || ["localhost"]
  hosts.each do |host|
    properties[:databases].each do |db|
      unless db == "*"
        mysql_database db do
          action properties.fetch(:action, :create_db)
        end
      end

      mysql_database db do
        new_username user
        new_password properties[:password]
        new_username_host host
        new_username_privileges properties[:privileges]
        action properties.fetch(:action, :grant_privileges)
      end
    end
  end

  # Create .my.cnf for user, automated logins
  #
  mysql_database "*" do
    username user
    password properties[:password]
    action :generate_mycnf
  end
end
