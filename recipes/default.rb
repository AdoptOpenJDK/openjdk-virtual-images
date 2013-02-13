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
directory node[:openjdk][:dir][:hgforest] do
	owner "root"
	mode "0755"
	action :create
end
directory node[:openjdk][:dir][:source] do
	owner "root"
	mode "0755"
	action :create
end

mercurial node[:openjdk][:dir][:hgforest]  do
  repository "https://bitbucket.org/pmezard/hgforest-crew/overview/"
  mode "0755"
  action :sync
end

file "/home/vagrant/.hgrc" do 
	content <<-EOS
forest = #{node[:openjdk][:dir][:hgforest]}forest.py
	EOS
	mode 0755
end
