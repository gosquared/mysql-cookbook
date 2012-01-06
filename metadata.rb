maintainer        "Gerhard Lazu"
maintainer_email  "gerhard@lazu.co.uk"
license           "Apache 2.0"
description       "Installs and configures mysql for client or server"
version           "1.0.0"

recipe            "mysql", "Includes the client recipe to configure a client"
recipe            "mysql::client", "Installs packages required for mysql clients using run_action magic"
recipe            "mysql::server", "Installs packages required for mysql servers w/o manual intervention"
recipe            "mysql::server_ec2", "Performs EC2-specific mountpoint manipulation"
recipe            "mysql::ebs_datastore", "Configure mysql datatstore for use with ebs mountpoint"

supports "ubuntu"

depends "bootstrap" # https://github.com/gchef/bootstrap
