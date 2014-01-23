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
package = %w{unzip zip mercurial build-essential libX11-dev libxext-dev libxrender-dev libxtst-dev libxt-dev libfreetype6-dev libcups2-dev libasound2-dev ccache}

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
openjdk_dirs = %w{ node[:openjdk9][:home]
		  node[:openjdk9][:dir]
		  node[:openjdk9][:forest] 
		  node[:openjdk9][:workspace] 
		  node[:openjdk9][:jtreg][:dir]}

openjdk_dirs.each do |dir|
   directory eval("#{dir}") do      
	  # had to temp change the mode to 755 due to problem with permissions of hg clone
      mode "0755"
      owner node[:user]
      group node[:user]
      action :create
   end
end

remote_file node[:openjdk9][:jtreg][:file] do
	source node[:openjdk9][:jtreg][:url]
	checksum node[:openjdk9][:jtreg][:checksum]
	mode "0755"
	action :create_if_missing
end

remote_file node[:openjdk9][:jdk8ea][:file] do
	source node[:openjdk9][:jdk8ea][:url]
	checksum node[:openjdk9][:jdk8ea][:checksum]
	mode "0755"
	action :create_if_missing
end

execute "get_sources_from_mercurial_jdk9" do
	user node[:user]
	cwd node[:openjdk9][:workspace]
	command "hg clone #{node[:openjdk9][:source_url]} #{node[:openjdk9][:workspace]}/#{node[:openjdk9][:repo]}"
	not_if { ::File.exist?("#{node[:openjdk9][:workspace]}/#{node[:openjdk9][:repo]}") } # only if the jdk9 folder does NOT exists
end

execute "get_source" do
	user node[:user]
	cwd node[:openjdk9][:source_tl]
	command "sh #{node[:openjdk9][:get_source]}"
end

execute "install_jdk8ea" do
	user node[:user]
	cwd node[:openjdk9][:home]
	command "tar -zxvf #{node[:openjdk9][:jdk8ea][:file]}"
end

execute "auto_configure" do
	user node[:user]
	cwd node[:openjdk9][:source_tl]
	command "bash configure --with-boot-jdk=#{node[:openjdk9][:home]}/jdk1.8.0"
end

execute "configure_jtreg" do
	user node[:user]
	cwd node[:openjdk9][:dir]
	command "tar -zxvf #{node[:openjdk9][:jtreg][:file]}"
	creates "#{node[:openjdk9][:jtreg][:file]}"
end


execute "build_openjdk_clean_images" do 
	user node[:user]
	cwd node[:openjdk9][:source_tl]
	command "make clean images"

	environment ({'HOME' => '/home/openjdk'})
	timeout 72000
	not_if { ::File.exist?("#{node[:openjdk9][:build_log_file]}") } # only if the build.log file does NOT exists
end

execute "build_openjdk_images" do 
	user node[:user]
	cwd node[:openjdk9][:source_tl]
	command "make images"

	environment ({'HOME' => '/home/openjdk'})
	timeout 72000
	only_if { ::File.exist?("#{node[:openjdk9][:build_log_file]}") } # only if the build.log file does exist
end

bash "set_jtreg_export_variables" do
  code <<-EOS
    export JT_HOME=#{node[:openjdk9][:jtreg][:dir]}
    export PRODUCT_HOME=#{node[:openjdk9][:product_home]}
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