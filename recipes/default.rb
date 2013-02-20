# Author : Kaushal Singh <home.ksingh@gmail.com>
# Cookbook Name:: Openjdk
# Recipe:: default	
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# instaling dependancy packages
package = %w{unzip zip libX11-dev libxext-dev libxrender-dev libxtst-dev libfreetype6-dev libcups2-dev libasound2-dev ccache g++-4.6-multilib}

package.each do |pkg|
	r = package pkg do
		action [:install]
	end
end

#openjdk_dirs = %w{#node[:openjdk][:dir] #node[:openjdk][:forest] #node[:openjdk][:source] #node[:openjdk][:jtreg][:dir]}

#openjdk_dirs.each do |dir|
#	directory dir do
#	mode "0777"
#	owner "root"
#	action :create
#	recursive true
#	end
#end

directory node[:openjdk][:dir] do
	owner "root"
	mode "0755"
	action :create
end
directory node[:openjdk][:forest] do
	owner "root"
	mode "0755"
	action :create
end

directory node[:openjdk][:source] do
	owner "root"
	mode "0777"
	action :create
end

directory node[:openjdk][:jtreg][:dir] do
        owner "root"
        mode "0777"
        action :create
end

remote_file node[:openjdk][:jtreg][:file] do
	source node[:openjdk][:jtreg][:url]
	checksum node[:openjdk][:jtreg][:checksum]
	mode "0777"
	action :create_if_missing
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

file node[:openjdk][:hgrc] do 
	content <<-EOS
forest = #{node[:openjdk][:forest]}forest.py
	EOS
	mode "0755"
end

execute "get_source" do
	user "root"        
	cwd node[:openjdk][:source]
	command "sh #{node[:openjdk][:get_source]}"
end

execute "auto_configure" do
	user "root"
	cwd node[:openjdk][:source]
	command "bash configure"
end

execute "configure_jtreg" do
	user "root"
	cwd node[:openjdk][:jtreg][:dir]
	command "unzip -u #{node[:openjdk][:jtreg][:file]}"
end

execute "build_openjdk_images" do 
	user "root"
	cwd node[:openjdk][:source]
	command "make clean images"
end

file node[:openjdk][:export_path] do
  content <<-EOS
    export JT_HOME=#{node[:openjdk][:jtreg][:dir]}
    export PRODUCT_HOME=#{node[:openjdk][:product_home]}
  EOS
  mode 0755
end
