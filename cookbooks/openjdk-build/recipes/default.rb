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
package = %w{unzip zip mercurial openjdk-7-jdk  build-essential libX11-dev libxext-dev libxrender-dev libxtst-dev libxt-dev libfreetype6-dev libcups2-dev libasound2-dev ccache}

package.each do |pkg|
	r = package pkg do
		action [:install]
	end
end

# code to create openjdk directory TODO
openjdk_dirs = %w{node[:openjdk][:dir]
		  node[:openjdk][:forest] 
		  node[:openjdk][:source] 
		  node[:openjdk][:source_tl]
		  node[:openjdk][:jtreg][:dir]}

openjdk_dirs.each do |dir|
   directory eval("#{dir}") do      
      mode "0557"
      owner node[:owner]
      group node[:owner]
      action :create
   end
end
#
remote_file node[:openjdk][:jtreg][:file] do
	source node[:openjdk][:jtreg][:url]
	checksum node[:openjdk][:jtreg][:checksum]
	mode "0755"
	action :create_if_missing
end

execute "get_sources_from_mercurial_jdk8tl" do
	user node[:owner]
	cwd node[:openjdk][:source_tl]
	command "hg clone http://hg.openjdk.java.net/jdk8/tl #{node[:openjdk][:source]}/#{node[:openjdk][:repo]}"
end


file node[:openjdk][:hgrc] do 
	content <<-EOS
forest = #{node[:openjdk][:forest]}forest.py
	EOS
	mode "0755"
end

# code to run all commands in one block TODO
#execute "build_and_configure_openjdk" do
#       user node[:owner]
## get openjdk source
#	cwd node[:openjdk][:source]
#       command "sh #{node[:openjdk][:get_source]}"
## configure node for openjdk 
#	cwd node[:openjdk][:source]
#	command "bash configure"
## configure jtreg
#	cwd node[:openjdk][:jtreg][:dir]
#        command "unzip -u #{node[:openjdk][:jtreg][:file]}"
## make openjdk image
#	cwd node[:openjdk][:source]
#        command "make clean images"

#end

execute "get_source" do
	user node[:owner]
	cwd node[:openjdk][:source_tl]
	command "sh #{node[:openjdk][:get_source]}"
end

execute "auto_configure" do
	user node[:owner]
	cwd node[:openjdk][:source_tl]
	command "bash configure"
end

execute "configure_jtreg" do
	user node[:owner]
	cwd node[:openjdk][:dir]
	command "unzip -u #{node[:openjdk][:jtreg][:file]}"
end

execute "build_openjdk_images" do 
	user node[:owner]
	cwd node[:openjdk][:source_tl]
	command "make clean images"
end

file node[:openjdk][:export_path] do
  content <<-EOS
    export JT_HOME=#{node[:openjdk][:jtreg][:dir]}
    export PRODUCT_HOME=#{node[:openjdk][:product_home]}
  EOS
  mode 0755
end
