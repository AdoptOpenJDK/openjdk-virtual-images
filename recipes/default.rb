# Cookbook Name:: Openjdk
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# this installing packge blog will and should go in loop... need to do, after POC
package = %w{unzip zip libX11-dev libxext-dev libxrender-dev libxtst-dev libfreetype6-dev libcups2-dev libasound2-dev ccache g++-4.6-multilib}

package.each do |pkg|
	r = package pkg do
		action [:install]
	end
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

execute "auto_configure" do
	user "root"
	cwd node[:openjdk][:source]
	command "bash configure"
end
