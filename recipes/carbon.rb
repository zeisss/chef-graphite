python_pip "carbon" do
  version node["graphite"]["version"]
  action :install
end

directory "storage dir" do
  path node["graphite"]["storage_dir"]
  action :create
  mode "0755"
  recursive true
  owner node["apache"]["user"]
  group node["apache"]["group"]
end

template "/opt/graphite/conf/carbon.conf" do
  mode "0644"
  source "carbon.conf.erb"
  owner node["apache"]["user"]
  group node["apache"]["group"]
  variables(
    :line_receiver_interface    => node["graphite"]["carbon"]["line_receiver_interface"],
    :pickle_receiver_interface  => node["graphite"]["carbon"]["pickle_receiver_interface"],
    :storage_dir                => node["graphite"]["storage_dir"],
    :cache_query_interface      => node["graphite"]["carbon"]["cache_query_interface"]
    :log_updates                => (node["graphite"]["carbon"]["cache_query_interface"] ? "True" : "False")
  )
  notifies :restart, "service[carbon-cache]"
end

template "/opt/graphite/conf/storage-schemas.conf" do
  mode "0644"
  source "storage-schemas.conf.erb"
  owner node["apache"]["user"]
  group node["apache"]["group"]
  notifies :restart, "service[carbon-cache]"
end

template "/opt/graphite/conf/storage-aggregation.conf" do
  mode "0644"
  source "storage-aggregation.conf.erb"
  owner node["apache"]["user"]
  group node["apache"]["group"]
  notifies :restart, "service[carbon-cache]"
end

execute "chown" do
  command "chown -R #{node["apache"]["user"]}:#{node["apache"]["group"]} #{node["graphite"]["storage_dir"]}"
  only_if do
    f = File.stat(node["graphite"]["storage_dir"])
    f.uid == 0 && f.gid == 0
  end
end

template "/etc/init/carbon-cache.conf" do
  mode "0644"
  source "carbon-cache.conf.erb"
  variables(:user => node["apache"]["user"])
end

logrotate_app "carbon" do
  cookbook "logrotate"
  path "#{node["graphite"]["storage_dir"]}/log/carbon-cache/carbon-cache-a/*.log"
  frequency "daily"
  rotate 7
  create "644 root root"
end

service "carbon-cache" do
  provider Chef::Provider::Service::Upstart
  action [ :enable, :start ]
end
