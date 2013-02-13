# Cookbook Name:: buildOpenjdk
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "git" do
	action [:install]
end

directory node[:buildOpenjdk][:dir][:openjdk] do
	owner "root"
	mode "0755"
	action :create
end
directory node[:buildOpenjdk][:dir][:hgforest] do
	owner "root"
	mode "0755"
	action :create
end
directory node[:buildOpenjdk][:dir][:source] do
	owner "root"
	mode "0755"
	action :create
end

mercurial node[:buildOpenjdk][:dir][:hgforest]  do
  repository "https://bitbucket.org/pmezard/hgforest-crew/overview/"
  mode "0755"
  action :sync
end

file "/home/vagrant/.hgrc" do 
	content <<-EOS
forest = #{node[:buildOpenjdk][:dir][:hgforest]}forest.py
	EOS
	mode 0755
end
