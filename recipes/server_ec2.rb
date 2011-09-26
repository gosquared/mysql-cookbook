if node[:mysql_ec2][:ebs_vol_dev]
  directory node[:mysql_ec2][:path] do
    owner "mysql"
    group "mysql"
    recursive true
  end

  bash "Add and mount the MySQL EBS volume if missing" do
    code %{
      if [ $(grep -c #{node[:mysql_ec2][:ebs_vol_dev]} /etc/fstab) -eq 0 ]; then
        mkfs.xfs #{node[:mysql_ec2][:ebs_vol_dev]}
        echo "#{node[:mysql_ec2][:ebs_vol_dev]} #{node[:mysql_ec2][:path]} xfs defaults,nobootwait,noatime 0 0" >> /etc/fstab
        mount #{node[:mysql_ec2][:ebs_vol_dev]}
      fi
    }
  end

  execute "Move MySQL files to the new EBS mount" do
    command %{
      if [ ! -L #{node[:mysql][:datadir]} ]; then
        /etc/init.d/mysql stop
        mv #{node[:mysql][:datadir]}/* #{node[:mysql_ec2][:path]}/
        rm -fr #{node[:mysql][:datadir]}
        ln -nfs #{node[:mysql_ec2][:path]} #{node[:mysql][:datadir]}
        /etc/init.d/mysql start
      fi
    }
  end
end
