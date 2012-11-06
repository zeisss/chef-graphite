include_recipe "apache2::mod_python"

[ "python-cairo-dev", "python-django", "python-django-tagging", "python-memcache", "python-rrdtool" ].each do |graphite_package|
  package graphite_package do
    action :install
  end
end

python_pip "graphite-web" do
  version node["graphite"]["version"]
  action :install
end

template "/opt/graphite/conf/graphTemplates.conf" do
  mode "0644"
  source "graphTemplates.conf.erb"
  owner node["apache"]["user"]
  group node["apache"]["group"]
  notifies :restart, "service[apache2]"
end

template "/opt/graphite/webapp/graphite/local_settings.py" do
  mode "0644"
  source "local_settings.py.erb"
  owner node["apache"]["user"]
  group node["apache"]["group"]
  variables(
    :storage_dir    => node["graphite"]["storage_dir"]
    :timezone       => node["graphite"]["dashboard"]["timezone"],
    :memcache_hosts => node["graphite"]["dashboard"]["memcache_hosts"]
  )
  notifies :restart, "service[apache2]"
end

apache_site "000-default" do
  enable false
end

sysadmins = search(:users, 'groups:sysadmin')
template "/opt/graphite/storage/httpusers" do
  source "htpasswd.users.erb"
  owner node["apache"]["user"]
  group node["apache"]["group"]
  mode 0644
  variables(
    :sysadmins => sysadmins
  )
end

web_app "graphite" do
  template "graphite.conf.erb"
  docroot "/opt/graphite/webapp"
  server_name node["graphite"]["dashboard"]["server_name"]
end

[ "log", "whisper" ].each do |dir|
  directory "#{node["graphite"]["storage_dir"]}/#{dir}" do
    owner node["apache"]["user"]
    group node["apache"]["group"]
  end
end

directory "#{node["graphite"]["storage_dir"]}/log/webapp" do
  owner node["apache"]["user"]
  group node["apache"]["group"]
end

cookbook_file "#{node["graphite"]["storage_dir"]}/graphite.db" do
  owner node["apache"]["user"]
  group node["apache"]["group"]
  action :create_if_missing
end

execute "Correct graphite.db permissions" do
  command "chown #{node["apache"]["user"]}:#{node["apache"]["group"]} #{node["graphite"]["storage_dir"]}/graphite.db"
  action :run
end

execute "Create missing database tables" do
  command "python /opt/graphite/webapp/graphite/manage.py syncdb"
  action :run
end

logrotate_app "dashboard" do
  cookbook "logrotate"
  path "#{node["graphite"]["storage_dir"]}/log/webapp/*.log"
  frequency "daily"
  rotate 7
  create "644 root root"
end
