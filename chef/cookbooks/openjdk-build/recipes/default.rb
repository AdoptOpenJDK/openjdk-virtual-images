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

user "openjdk" do
 comment "Openjdk User"
 uid 1005
 gid "users"
 home "/home/openjdk"
 shell "/bin/bash"
 password "$1$YAhmdiQ0$Th4Yolc3VTXnVfrIMRNGr."
 supports :manage_home=>true
end

gem_package "ruby-shadow" do
  action :install 
end

group "openjdk" do
  action :create
  append true
end


remote_file node[:jtreg][:file] do
  source node[:jtreg][:url]
  checksum node[:jtreg][:checksum]
  mode "0755"
  action :create_if_missing
end

execute "configure_jtreg" do
    user node[:user]
    cwd node[:home]
    command "tar -zxvf #{node[:jtreg][:file]}"
    creates "#{node[:jtreg][:dir]}"
end

file "#{node[:home]}/.bashrc" do
  group node[:user]
  user node[:user]
  mode 00755
  action :create
  not_if do
        File.exists?("#{node[:home]}/.bashrc")
  end
end

file "#{node[:home]}/.bash_profile" do
  group node[:user]
  user node[:user]
  mode 00755
  action :create

  content "if [ -r #{node[:home]}/.bashrc ] ; then
        . ~/.bashrc
  fi"

  not_if do
        File.exists?("#{node[:home]}/.bash_profile")
  end
end

node[:openjdk].each do |index, jdk|
    directory jdk[:workspace] do
          mode "0755"
          owner node[:user]
          group node[:user]
          action :create
    end

    bootJdkArgs=""
    bootJdk="/usr/bin/"

    if jdk[:bootstrap_jdk]
      remote_file jdk[:bootstrap_jdk][:file] do
            source jdk[:bootstrap_jdk][:url]
            checksum jdk[:bootstrap_jdk][:checksum]
            mode "0755"
            action :create_if_missing
      end

      execute "install_jdk8ea" do
              user node[:user]
              cwd node[:home]
              command "tar -zxvf #{jdk[:bootstrap_jdk][:file]}"
      end
      bootJdk="#{node[:home]}/#{jdk[:bootstrap_jdk][:sub_dir]}"
      bootJdkArgs="--with-boot-jdk=#{bootJdk}"
    end

    execute "get_sources_from_mercurial_jdk8tl" do
            user node[:user]
            cwd jdk[:workspace]
            command "hg clone #{jdk[:source_url]} #{jdk[:workspace]}/#{jdk[:repo]}"
            not_if { ::File.exist?("#{jdk[:workspace]}/#{jdk[:repo]}") }
    end

    execute "get_source" do
            user node[:user]
            cwd jdk[:source_tl]
            command "sh #{jdk[:get_source]}"
    end


    execute "auto_configure" do
            user node[:user]
            cwd jdk[:source_tl]
            command "bash configure #{bootJdkArgs}"
    end


    execute "build_openjdk_clean_images" do 
            user node[:user]
            cwd jdk[:source_tl]
            command "make clean images"

            environment ({'HOME' => '/home/openjdk'})
            timeout 72000
            not_if { ::File.exist?("#{jdk[:build_log_file]}") } # only if the build.log file does NOT exists
    end
    
    execute "build_openjdk_images" do 
    	user node[:user]
    	cwd jdk[:source_tl]
    	command "make images"
    
    	environment ({'HOME' => '/home/openjdk'})
    	timeout 72000
    	only_if { ::File.exist?("#{jdk[:build_log_file]}") } # only if the build.log file exists
    end


    ruby_block "include-bashrc" do
      block do
        file = Chef::Util::FileEdit.new("#{node[:home]}/.bashrc")
        file.insert_line_if_no_match(
                "export JAVA7_HOME",
                "export JAVA7_HOME=/usr/bin/")
        file.write_file
        file.insert_line_if_no_match(
                "export JAVA_HOME=",
                "export JAVA_HOME=#{bootJdk}")
        file.write_file    
        file.insert_line_if_no_match(
                "export JT_HOME",
                "export JT_HOME=#{node[:jtreg][:dir]}")
        file.write_file
            file.insert_line_if_no_match(
                    "export PRODUCT_HOME_JDK8",
                    "export PRODUCT_HOME_JDK8=#{jdk[:product_home]}")
            file.write_file
            file.insert_line_if_no_match(
                    "export PRODUCT_HOME=",
                    "export PRODUCT_HOME=$PRODUCT_HOME_JDK8")
            file.write_file
            file.insert_line_if_no_match(
                "export SOURCE_CODE",
                "export SOURCE_CODE=#{jdk[:workspace]}")
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
end
