maintainer        "Gerhard Lazu"
maintainer_email  "gerhard@lazu.co.uk"
license           "Apache 2.0"
description       "Installs and configures mysql for client or server"
version           "2.0.0"

recipe            "mysql", "Includes the client recipe to configure a client"
recipe            "mysql::client", "Installs packages required for mysql clients using run_action magic"
recipe            "mysql::client50", "Installs packages required for mysql clients, Ubuntu Hardy 5.0.96"
recipe            "mysql::server", "Installs packages required for mysql servers w/o manual intervention"
recipe            "mysql::server50", "Installs packages required for mysql servers w/o manual intervention, Ubuntu Hardy 5.0.96"
recipe            "mysql::server_ec2", "Performs EC2-specific mountpoint manipulation"
recipe            "mysql::ebs_datastore", "Configure mysql datatstore for use with ebs mountpoint"
recipe            "mysql::root_passwordless_loging", "Creates a .my.cnf for the root user to enable passwordless logins, exposes mysql root password in shell env"

supports "ubuntu"

depends "bootstrap" # https://github.com/gchef/bootstrap
