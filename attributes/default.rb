default[:mysql][:bind_address]  = ipaddress
default[:mysql][:port]          = 3306
default[:mysql][:datadir]       = "/var/lib/mysql"
default[:mysql][:confdir]       = '/etc/mysql'
default[:mysql][:socket]        = "/var/run/mysqld/mysqld.sock"
default[:mysql][:pid_file]      = "/var/run/mysqld/mysqld.pid"
default[:mysql][:old_passwords] = 0

default[:mysql][:root_password] = ""

default[:mysql][:users]         = []

default[:mysql_ec2][:path]         = "/mnt/mysql"
default[:mysql_ec2][:ebs_vol_dev]  = false
default[:mysql_ec2][:ebs_vol_size] = 10

default[:mysql_replication][:role]                           = false
default[:mysql_replication][:server_id]                      = 1
default[:mysql_replication][:innodb_flush_log_at_trx_commit] = 1
default[:mysql_replication][:sync_binlog]                    = 1
default[:mysql_replication][:auto_increment_offset]          = 2
default[:mysql_replication][:auto_increment_increment]       = 5
default[:mysql_replication][:master_host]                    = nil
default[:mysql_replication][:master_user]                    = nil
default[:mysql_replication][:master_password]                = nil

default[:mysql][:allow_remote_root]                 = false
default[:mysql][:tunable][:back_log]                = "128"
default[:mysql][:tunable][:key_buffer]              = "256M"
default[:mysql][:tunable][:max_allowed_packet]      = "16M"
default[:mysql][:tunable][:max_connections]         = "800"
default[:mysql][:tunable][:max_heap_table_size]     = "32M"
default[:mysql][:tunable][:myisam_recover]          = "BACKUP"
default[:mysql][:tunable][:net_read_timeout]        = "30"
default[:mysql][:tunable][:net_write_timeout]       = "30"
default[:mysql][:tunable][:table_cache]             = "128"
default[:mysql][:tunable][:table_open_cache]        = "128"
default[:mysql][:tunable][:thread_cache]            = "128"
default[:mysql][:tunable][:thread_cache_size]       = 8
default[:mysql][:tunable][:thread_concurrency]      = 10
default[:mysql][:tunable][:thread_stack]            = "256K"
default[:mysql][:tunable][:wait_timeout]            = "180"

default[:mysql][:tunable][:query_cache_limit]       = "1M"
default[:mysql][:tunable][:query_cache_size]        = "16M"

default[:mysql][:tunable][:slow_query_log_file]     = "/var/log/mysql/slow.log"
default[:mysql][:tunable][:long_query_time]         = 2

default[:mysql][:tunable][:expire_logs_days]        = 10
default[:mysql][:tunable][:max_binlog_size]         = "100M"

default[:mysql][:tunable][:innodb_buffer_pool_size] = "256M"
default[:mysql][:tunable][:innodb_additional_mem_pool_size] = 1048576
default[:mysql][:tunable][:innodb_log_file_size]    = 5242880
default[:mysql][:tunable][:ignore_builtin_innodb]   = false
default[:mysql][:tunable][:innodb_log_buffer_size]  = 1048576
default[:mysql][:tunable][:innodb_flush_log_at_trx_commit]  = 1
default[:mysql][:tunable][:innodb_lock_wait_timeout]  = 50
default[:mysql][:tunable][:innodb_file_per_table]   = false

default[:mysql][:tunable][:sort_buffer_size]        = 8388608
default[:mysql][:tunable][:read_buffer_size]        = 131072
default[:mysql][:tunable][:read_rnd_buffer_size]    = 262144
default[:mysql][:tunable][:myisam_sort_buffer_size] = 8388608
