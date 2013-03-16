default[:mysql][:bind_address]  = ipaddress
default[:mysql][:port]          = 3306
default[:mysql][:datadir]       = '/var/lib/mysql'
default[:mysql][:confdir]       = '/etc/mysql'
default[:mysql][:socket]        = '/var/run/mysqld/mysqld.sock'
default[:mysql][:pid_file]      = '/var/run/mysqld/mysqld.pid'
default[:mysql][:old_passwords] = 0
default[:mysql][:init]          = "sysv"

### Users
#
default[:mysql][:root_password]     = ''
default[:mysql][:users]             = []

### Logging
#
# Only enable this if you don't care about performance.
# STRONGLY DISCOURAGED in production
default[:mysql][:log_file] = false
# Enable if you want the logging to go to syslog.
# Debian improvement...
default[:mysql][:syslog] = false
default[:mysql][:slow_query_log_file] = '/var/log/mysql/slow.log'
default[:mysql][:long_query_time] = 2
# The following can be used as easy to replay backup logs or for replication.
default[:mysql][:expire_logs_days] = 14
default[:mysql][:max_binlog_size] = '100M'
default[:mysql][:back_log] = '128'

### Replication
#
default[:mysql_replication][:role]                           = false
default[:mysql_replication][:server_id]                      = 1
default[:mysql_replication][:innodb_flush_log_at_trx_commit] = 1
default[:mysql_replication][:sync_binlog]                    = 1
default[:mysql_replication][:auto_increment_offset]          = 2
default[:mysql_replication][:auto_increment_increment]       = 5
default[:mysql_replication][:master_host]                    = nil
default[:mysql_replication][:master_user]                    = nil
default[:mysql_replication][:master_password]                = nil


## InnoDB
#
default[:mysql][:innodb][:ignore_builtin]           = false
default[:mysql][:innodb][:buffer_pool_size]         = '256M'
default[:mysql][:innodb][:additional_mem_pool_size] = '1M'
default[:mysql][:innodb][:log_file_size]            = '16M'
default[:mysql][:innodb][:log_buffer_size]          = '1M'
default[:mysql][:innodb][:flush_log_at_trx_commit]  = 1
default[:mysql][:innodb][:lock_wait_timeout]        = 50
default[:mysql][:innodb][:file_per_table]           = false

default[:mysql][:tunable][:query_cache_limit]       = '1M'
default[:mysql][:tunable][:query_cache_size]        = '16M'
default[:mysql][:tunable][:key_buffer]              = '256M'
default[:mysql][:tunable][:max_allowed_packet]      = '16M'
default[:mysql][:tunable][:max_connections]         = '800'
default[:mysql][:tunable][:max_heap_table_size]     = '32M'
# This replaces the startup script and checks MyISAM tables if needed
# the first time they are touched
default[:mysql][:tunable]['myisam-recover']          = 'BACKUP'
default[:mysql][:tunable][:net_read_timeout]        = '30'
default[:mysql][:tunable][:net_write_timeout]       = '30'
default[:mysql][:tunable][:table_cache]             = '128'
default[:mysql][:tunable][:table_open_cache]        = '128'
default[:mysql][:tunable][:thread_cache]            = '128'
default[:mysql][:tunable][:thread_cache_size]       = 8
default[:mysql][:tunable][:thread_concurrency]      = 10
default[:mysql][:tunable][:thread_stack]            = '256K'
default[:mysql][:tunable][:wait_timeout]            = '180'
default[:mysql][:tunable][:sort_buffer_size]        = '8M'
default[:mysql][:tunable][:read_buffer_size]        = '128K'
default[:mysql][:tunable][:read_rnd_buffer_size]    = '256K'
default[:mysql][:tunable][:myisam_sort_buffer_size] = '8M'
