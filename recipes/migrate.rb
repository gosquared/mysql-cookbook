node[:mysql][:migrate].each do |host|
  if `ping -c 1 -W 1 #{host[:hostname]}`.index(/1 (?:packets )?received/)
    bash "Adding #{host[:hostname]} to known hosts ..." do
      code %{
        #for domain in "#{host[:hostname]}"
        #do
          domain="#{host[:hostname]}"
          if [ $(ssh-keygen -F $domain | grep -c found) -lt 1 ]; then
            # Create known_hosts file if missing
            [ ! -f ~/.ssh/known_hosts ] && touch ~/.ssh/known_hosts && chmod 600 ~/.ssh/known_hosts
            ssh-keyscan $domain >> ~/.ssh/known_hosts
          fi
        #done
      }
    end

    host[:databases].each do |db, properties|
      bash "Migrating #{db} db from #{host[:hostname]} ..." do
        cwd "/var/chef"
        code %{
          ssh -t #{host[:username]}@#{host[:hostname]} sudo mysqldump --defaults-file=/root/.my.cnf #{db} | bzip2 > /var/chef/#{db}.sql.bz2
          rsync --delete --verbose --progress -e #{host[:username]}@#{host[:hostname]} /var/chef/#{db}.sql.bz2
        }
        only_if(ENV['FORCED_MIGRATE'] || "[ ! -f /var/chef/#{db}.sql.bz2 ]")
      end

      mysql_database db do
        action :create_db
      end

      mysql_database db do
        new_username properties[:username]
        new_password properties[:password]
        new_username_host properties[:host]
        action :create_user
      end

      mysql_database db do
        new_username properties[:username]
        new_username_host properties[:host]
        action :grant_privileges
      end

      mysql_database db do
        mysqldump "/var/chef/#{db}.sql.bz2"
        action :import
      end
    end
  else
    Chef::Log.error("MySQL migration: cannot ping #{host[:hostname]}. Are pings allowed? Is the host reachable?")
  end
end
