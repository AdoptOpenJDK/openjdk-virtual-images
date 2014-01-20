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
package = %w{unzip zip mercurial openjdk-7-jdk build-essential libX11-dev libxext-dev libxrender-dev libxtst-dev libxt-dev libfreetype6-dev libcups2-dev libasound2-dev ccache}

package.each do |pkg|
	r = package pkg do
		action [:install]
	end
end 

gem_package "ruby-shadow" do
  action :install 
end

group "openjdk" do
  action :create
  append true
end

user "openjdk" do
 comment "Openjdk User"
 uid 1005
 gid "openjdk"
 home "/home/openjdk"
 shell "/bin/bash"
 password "$1$YAhmdiQ0$Th4Yolc3VTXnVfrIMRNGr."
end

# code to create openjdk directory TODO
openjdk_dirs = %w{ node[:openjdk][:home]
		  node[:openjdk][:dir]
		  node[:openjdk][:forest] 
		  node[:openjdk][:workspace] 
		  node[:openjdk][:jtreg][:dir]}

openjdk_dirs.each do |dir|
   directory eval("#{dir}") do      
	  # had to temp change the mode to 755 due to problem with permissions of hg clone
      mode "0755"
      owner node[:user]
      group node[:user]
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
	user node[:user]
	cwd node[:openjdk][:workspace]
	command "hg clone #{node[:openjdk][:source_url]} #{node[:openjdk][:workspace]}/#{node[:openjdk][:repo]}"
	creates "#{node[:openjdk][:workspace]}/#{node[:openjdk][:repo]}"

end


# code to run all commands in one block TODO
#execute "build_and_configure_openjdk" do
#       user node[:owner]
## get openjdk source
#	cwd node[:openjdk][:workspace]
#       command "sh #{node[:openjdk][:get_source]}"
## configure node for openjdk 
#	cwd node[:openjdk][:workspace]
#	command "bash configure"
## configure jtreg
#	cwd node[:openjdk][:jtreg][:dir]
#        command "unzip -u #{node[:openjdk][:jtreg][:file]}"
## make openjdk image
#	cwd node[:openjdk][:workspace]
#        command "make clean images"

#end

execute "get_source" do
	user node[:user]
	cwd node[:openjdk][:source_tl]
	command "sh #{node[:openjdk][:get_source]}"
end

execute "auto_configure" do
	user node[:user]
	cwd node[:openjdk][:source_tl]
	command "bash configure"
end

execute "configure_jtreg" do
	user node[:user]
	cwd node[:openjdk][:dir]
	command "tar -zxvf #{node[:openjdk][:jtreg][:file]}"
end

execute "build_openjdk_images" do 
	user node[:user]
	cwd node[:openjdk][:source_tl]
	command "make clean images"
	environment ({'HOME' => '/home/openjdk'})
end

bash "set_jtreg_export_variables" do
  code <<-EOS
    export JT_HOME=#{node[:openjdk][:jtreg][:dir]}
    export PRODUCT_HOME=#{node[:openjdk][:product_home]}
    export SOURCE_CODE=$HOME/workspace
    export JTREG_INSTALL=$HOME/jtreg
    export JTREG_HOME=$JTREG_INSTALL
    export JT_HOME=$JTREG_INSTALL
    export JPRT_JTREG_HOME=${JT_HOME}
    export JPRT_JAVA_HOME=${PRODUCT_HOME}=
    export JTREG_TIMEOUT_FACTOR=5
    export CONCURRENCY=auto
    EOS
end
