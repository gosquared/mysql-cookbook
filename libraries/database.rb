begin
  require 'mysql'
rescue LoadError
  Chef::Log.error("Missing gem 'mysql'")
end

module MySQL
  module Database

    def mysql
      @mysql ||= ::Mysql.new(
        new_resource.host,
        "root",
        (ENV['MYSQL_ROOT_PASSWORD'] || node[:mysql][:root_password])
      )
    end

    def close
      @mysql.close rescue nil
      @mysql = nil
    end

    def exists?
      mysql.list_dbs.include? new_resource.name
    end

    def user_exists?
      mysql.select_db('mysql')
      users = []
      mysql.query('SELECT user AS name, host FROM user').each_hash { |user| users << user }
      users.find do |user|
        user["name"] == new_resource.new_username && user["host"] == new_resource.new_username_host
      end
    end

    # errors if user has no privileges for that particular host
    # do we really need this check?
    # def privileges_match?
    #   mysql.query("SHOW GRANTS FOR '#{new_resource.new_username}'@'#{new_resource.new_username_host}'").each do |grant|
    #     grant = grant.first if grant.is_a? Array
    #     if grant.index(new_resource.new_username_privileges) && grant.index(new_resource.name)
    #       Chef::Log.debug("~~~ #{new_resource.new_username} has all privileges for #{new_resource.name}")
    #       return true
    #     end
    #   end
    #   false
    # end

    def mysql_run(condition="exists?", &block)
      if eval(condition)
        begin
          yield
          new_resource.updated_by_last_action(true)
        ensure
          mysql.close
        end
      end
    end
  end
end
