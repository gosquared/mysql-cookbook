if node[:mysql][:ebs_datastore][:mountpoint]
  directory node[:mysql][:ebs_datastore][:mountpoint] do
    owner "mysql"
    group "mysql"
    recursive true
  end

  execute "Move MySQL files to the new EBS mount" do
    command %{
      if [ ! -L #{node[:mysql][:datadir]} ]; then
        /etc/init.d/mysql stop
        mv #{node[:mysql][:datadir]}/* #{node[:mysql][:ebs_datastore][:mountpoint]}/
        rm -fr #{node[:mysql][:datadir]}
        ln -nfs #{node[:mysql][:ebs_datastore][:mountpoint]} #{node[:mysql][:datadir]}
        /etc/init.d/mysql start
      fi
    }
  end
end
