if node[:mysql_replication] && node[:mysql_replication].has_key(:role)
  template "/etc/mysql/conf.d/mysqld_replication.cnf" do
    cookbook "mysql"
    source "mysqld_replication.cnf.erb"
    mode "0644"
    notifies :restart, resources(:service => "mysql")
  end
end

# There's still a manual process involved, will automate all those steps at some point
#
# SLAVE:
# mysql-client: STOP SLAVE;
#
# MASTER:
# mysql-client: SHOW MASTER STATUS;
# mysql-client: FLUSH TABLES WITH READ LOCK;                # Flush all tables and block write statements:
# shell: mysqldump --all-databases --master-data > db.dump   # Automatically appends the change master on the slave to start the repication process
# mysql-client: UNLOCK TABLES;                              # Release the read lock
#
# SLAVE:
# import data from mysqldump
# mysql-client: START SLAVE;
# mysql-client: SHOW SLAVE STATUS \G;
# mysql-client: SHOW PROCESSLIST \G;
# mysql-client: SHOW SLAVE HOSTS;
