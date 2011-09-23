actions   :flush_tables_with_read_lock,
          :unflush_tables,
          :create_db,
          :create_user,
          :grant_privileges,
          :generate_mycnf,
          :query,
          :import

attribute :host,                      :kind_of => String,  :default => "localhost"
attribute :username,                  :kind_of => String,  :default => "root"
attribute :password,                  :kind_of => String

attribute :new_username,              :kind_of => String
attribute :new_username_privileges,   :kind_of => String,  :default => "SELECT, INSERT, UPDATE, DELETE, INDEX, ALTER"
attribute :new_username_host,         :kind_of => String,  :default => "localhost"
attribute :new_password,              :kind_of => String

attribute :database,                  :kind_of => String
attribute :sql,                       :kind_of => String
attribute :exists,                    :default => false

attribute :mysqldump,                 :kind_of => String
