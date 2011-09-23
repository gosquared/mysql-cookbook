include MySQL::Database

action :flush_tables_with_read_lock do
  mysql_run do
    Chef::Log.info "mysql_database: flushing tables with read lock"
    mysql.query("FLUSH TABLES WITH READ LOCK")
  end
end

action :unflush_tables do
  mysql_run do
    Chef::Log.info "mysql_database: unlocking tables"
    mysql.query("UNLOCK TABLES")
  end
end

action :create_db do
  mysql_run("!exists?") do
    Chef::Log.info "mysql_database: Creating database #{new_resource.name}"
    mysql.query("CREATE DATABASE #{new_resource.name}")
  end
end

action :create_user do
  mysql_run("!user_exists?") do
    Chef::Log.info "Creating user #{new_resource.new_username}"
    mysql.query("CREATE USER '#{new_resource.new_username}'@'#{new_resource.new_username_host}' IDENTIFIED BY '#{new_resource.new_password}'")
  end
end

action :grant_privileges do
  # Always run this
  mysql_run("true") do
    Chef::Log.info "Granting privileges to user #{new_resource.new_username} for #{new_resource.name}"
    mysql.query("GRANT #{new_resource.new_username_privileges} ON #{new_resource.name}.* TO '#{new_resource.new_username}'@'#{new_resource.new_username_host}' IDENTIFIED BY '#{new_resource.new_password}'")
    mysql.query("FLUSH PRIVILEGES")
  end
end

action :generate_mycnf do
  home_dir = new_resource.username == "root" ? "/root" : "/home/#{new_resource.username}"

  # do not attempt this for users which don't have a home folder
  #
  if ::File.exists? home_dir
    # Always run this
    mysql_run("true") do
      Chef::Log.info "Adding .my.cnf to #{new_resource.username}"
      template "#{home_dir}/.my.cnf" do
        source "user.my.cnf.erb"
        cookbook "mysql"
        owner new_resource.username
        group new_resource.username
        mode 0644
        variables(
          :username => new_resource.username,
          :password => new_resource.password
        )
      end
    end
  end
end

action :query do
  mysql_run do
    Chef::Log.info "mysql_database: Performing Query: #{new_resource.sql}"
    mysql.query(new_resource.sql)
  end
end

# This ought to re-use the same mysql_run method...
#
action :import do
  if new_resource.mysqldump.end_with? "gz"
    uncompress = "gunzip"
  elsif new_resource.mysqldump.end_with? "bz2"
    uncompress = "bunzip2"
  else
    return Chef::Log.error "MySQL dump file must be either gz or bz2, you've given me #{new_resource.mysqldump}"
  end

  execute "Importing database #{new_resource.name} from file #{new_resource.mysqldump}" do
    command %{
      #{uncompress} < #{new_resource.mysqldump} | mysql -u #{new_resource.username} #{new_resource.name}
    }
    only_if(ENV['FORCE'] || %{[ ! "$(mysql -e 'use #{new_resource.name}; show tables;')" ]})
  end
  new_resource.updated_by_last_action(true)
end

def load_current_resource
  Gem.clear_paths
  require 'mysql'

  @mysqldb = Chef::Resource::MysqlDatabase.new(new_resource.name)
  @mysqldb.database(new_resource.name)
end
