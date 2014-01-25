# Author : Adopt OpenJDK adopt-openjdk@googlegroups.com
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
openjdk_dirs = %w{ node[:openjdk8][:home]
		  node[:openjdk8][:dir]
		  node[:openjdk8][:forest] 
		  node[:openjdk8][:workspace] 
		  node[:openjdk8][:jtreg][:dir]}

openjdk_dirs.each do |dir|
   directory eval("#{dir}") do      
	  # had to temp change the mode to 755 due to problem with permissions of hg clone
      mode "0755"
      owner node[:user]
      group node[:user]
      action :create
   end
end

remote_file node[:openjdk8][:jtreg][:file] do
	source node[:openjdk8][:jtreg][:url]
	checksum node[:openjdk8][:jtreg][:checksum]
	mode "0755"
	action :create_if_missing
end

execute "get_sources_from_mercurial_jdk8tl" do
	user node[:user]
	cwd node[:openjdk8][:workspace]
	command "hg clone #{node[:openjdk8][:source_url]} #{node[:openjdk8][:workspace]}/#{node[:openjdk8][:repo]}"
	#creates "#{node[:openjdk8][:workspace]}/#{node[:openjdk8][:repo]}"
	not_if { ::File.exist?("#{node[:openjdk8][:workspace]}/#{node[:openjdk8][:repo]}") } # only if the jdk8_tl folder does NOT exists
end

execute "get_source" do
	user node[:user]
	cwd node[:openjdk8][:source_tl]
	command "sh #{node[:openjdk8][:get_source]}"
end

execute "auto_configure" do
	user node[:user]
	cwd node[:openjdk8][:source_tl]
	command "bash configure"
end

execute "configure_jtreg" do
	user node[:user]
	cwd node[:openjdk8][:dir]
	command "tar -zxvf #{node[:openjdk8][:jtreg][:file]}"
end

execute "build_openjdk_clean_images" do 
	user node[:user]
	cwd node[:openjdk8][:source_tl]
	command "make clean images"

	environment ({'HOME' => '/home/openjdk'})
	timeout 72000
	not_if { ::File.exist?("#{node[:openjdk8][:build_log_file]}") } # only if the build.log file does NOT exists
end

execute "build_openjdk_images" do 
	user node[:user]
	cwd node[:openjdk8][:source_tl]
	command "make images"

	environment ({'HOME' => '/home/openjdk'})
	timeout 72000
	only_if { ::File.exist?("#{node[:openjdk8][:build_log_file]}") } # only if the build.log file exists
end

file "#{node[:openjdk8][:home]}/.bashrc" do
  group node[:user]
  user node[:user]
  mode 00755
  action :create
  not_if do
  	File.exists?("#{node[:openjdk8][:home]}/.bashrc")
  end
end

ruby_block "include-bashrc" do
  block do
    file = Chef::Util::FileEdit.new("#{node[:openjdk8][:home]}/.bashrc")
    file.insert_line_if_no_match(
	    "export JAVA_HOME7",
	    "export JAVA_HOME7=/usr/bin/")
    file.write_file
    file.insert_line_if_no_match(
	    "export JAVA_HOME=",
	    "export JAVA_HOME=$JAVA_HOME7")
    file.write_file    
    file.insert_line_if_no_match(
	    "export JT_HOME",
	    "export JT_HOME=#{node[:openjdk8][:jtreg][:dir]}")
    file.write_file
	file.insert_line_if_no_match(
		"export PRODUCT_HOME_JDK8",
		"export PRODUCT_HOME_JDK8=#{node[:openjdk8][:product_home]}")
	file.write_file
	file.insert_line_if_no_match(
	 	"export PRODUCT_HOME=",
	 	"export PRODUCT_HOME=$PRODUCT_HOME_JDK8")
	file.write_file
	file.insert_line_if_no_match(
	    "export SOURCE_CODE",
	    "export SOURCE_CODE=#{node[:openjdk9][:workspace]}")
	file.write_file
	file.insert_line_if_no_match(
	    "export JTREG_INSTALL",
	    "export JTREG_INSTALL=$JT_HOME")
	file.write_file
	file.insert_line_if_no_match(
	    "export JTREG_HOME",
	    "export JTREG_HOME=$JTREG_INSTALL")
	file.write_file
	file.insert_line_if_no_match(	    
	    "export JT_HOME",
	    "export JT_HOME=$JTREG_INSTALL")
	file.write_file
	file.insert_line_if_no_match(
	    "export JPRT_JTREG_HOME",
	    "export JPRT_JTREG_HOME=$JT_HOME")
	file.write_file
	file.insert_line_if_no_match(
	    "export JPRT_JAVA_HOME",
	    "export JPRT_JAVA_HOME=$PRODUCT_HOME")
	file.write_file
	file.insert_line_if_no_match(
	    "export JTREG_TIMEOUT_FACTOR",
	    "export JTREG_TIMEOUT_FACTOR=5")
	file.write_file
	file.insert_line_if_no_match(
	    "export CONCURRENCY",
	    "export CONCURRENCY=auto")
	file.write_file
    file.insert_line_if_no_match(	    
	    "function switchToJDK8",
		"function switchToJDK8 {
			export JAVA_HOME=$JAVA7_HOME
			export PRODUCT_HOME=$PRODUCT_HOME_JDK8
		}")
    file.write_file
  end
end

file "#{node[:openjdk8][:home]}/.bash_profile" do
  group node[:user]
  user node[:user]
  mode 00755
  action :create

  content "if [ -r #{node[:openjdk8][:home]}/.bashrc ] ; then
  	. ~/.bashrc
  fi"

  not_if do
  	File.exists?("#{node[:openjdk8][:home]}/.bash_profile")
  end
end