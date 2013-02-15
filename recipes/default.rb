# Cookbook Name:: Openjdk
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "git" do
	action [:install]
end

directory node[:openjdk][:dir] do
	owner "root"
	mode "0755"
	action :create
end
directory node[:openjdk][:forest] do
	#owner "root"
	mode "0755"
	action :create
end
directory node[:openjdk][:source] do
	owner "vagrant"
	mode "0777"
	action :create
end

mercurial node[:openjdk][:forest]  do
	repository node[:openjdk][:forest_url]
	mode "0755"
	action :sync
end
mercurial node[:openjdk][:source] do 
	repository node[:openjdk][:source_url]
	mode "0755"
	action :sync	
end

file "/home/vagrant/.hgrc" do 
	content <<-EOS
forest = #{node[:openjdk][:forest]}forest.py
	EOS
	mode 0755
end

execute "get source" do
	user "root"        
	cwd node[:openjdk][:source]
	command "sh #{node[:openjdk][:get_source]}"
end
