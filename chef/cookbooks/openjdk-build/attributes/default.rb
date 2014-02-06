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
# constants for building OpenJdk.
default[:user] = "openjdk"
default[:owner] = "root"
default[:machine][:arch] = kernel['machine']
default[:home] = "/home/#{node[:user]}"

#download and configure jtreg
default[:jtreg][:dir] = "#{node[:home]}/jtreg"
default[:jtreg][:file] = "#{node[:home]}/jtreg.tar.gz" 
default[:jtreg][:url] = "https://adopt-openjdk.ci.cloudbees.com/job/jtreg/lastSuccessfulBuild/artifact/jtreg-4.2.0-SNAPSHOT.tar.gz"
default[:jtreg][:checksum] ="2ccacd2550f8094f0dcd1601748add3e"

default[:openjdk][:jdk8][:repo] = "jdk8_tl"
default[:openjdk][:jdk8][:forest] = "#{node[:home]}/hgforest"
default[:openjdk][:jdk8][:workspace] = "#{node[:home]}/workspace"
default[:openjdk][:jdk8][:source_tl] = "#{node[:openjdk][:jdk8][:workspace]}/#{node[:openjdk][:jdk8][:repo]}"
default[:openjdk][:jdk8][:source_url] = "http://hg.openjdk.java.net/jdk8/tl"
default[:openjdk][:jdk8][:forest_url] = "https://bitbucket.org/pmezard/hgforest-crew/overview/"
default[:openjdk][:jdk8][:get_source] = "#{node[:openjdk][:jdk8][:source_tl]}/get_source.sh"

default[:openjdk][:jdk8][:product_home] = "#{node[:openjdk][:jdk8][:source_tl]}/build/linux-#{node[:machine][:arch]}-normal-server-release/images/j2sdk-image/"
default[:openjdk][:jdk8][:export_path] = "/etc/profile.d/openjdk_build_path.sh"

default[:openjdk][:jdk8][:build_log_file] = "#{node[:openjdk][:jdk8][:source_tl]}/build/linux-#{node[:machine][:arch]}-normal-server-release/build.log"



default[:openjdk][:jdk9][:repo] = "jdk9"
default[:openjdk][:jdk9][:forest] = "#{node[:home]}/hgforest9"
default[:openjdk][:jdk9][:workspace] = "#{node[:home]}/workspace9"
default[:openjdk][:jdk9][:source_tl] = "#{node[:openjdk][:jdk9][:workspace]}/#{node[:openjdk][:jdk9][:repo]}"
default[:openjdk][:jdk9][:source_url] = "http://hg.openjdk.java.net/jdk9/jdk9"
default[:openjdk][:jdk9][:forest_url] = "https://bitbucket.org/pmezard/hgforest-crew/overview/"
default[:openjdk][:jdk9][:get_source] = "#{node[:openjdk][:jdk9][:source_tl]}/get_source.sh"


default[:openjdk][:jdk9][:product_home] = "#{node[:openjdk][:jdk9][:source_tl]}/build/linux-#{node[:machine][:arch]}-normal-server-release/images/j2sdk-image/"
default[:openjdk][:jdk9][:export_path] = "/etc/profile.d/openjdk_build_path.sh"

#download jdk8ea and install into /usr/lib/jdk1.8.0
default[:openjdk][:jdk9][:bootstrap_jdk][:file] = "#{node[:home]}/jdk-8-ea-b123.tar.gz" 
default[:openjdk][:jdk9][:bootstrap_jdk][:url] = "http://www.java.net/download/jdk8/archive/b123/binaries/jdk-8-ea-bin-b123-linux-x64-10_jan_2014.tar.gz"
default[:openjdk][:jdk9][:bootstrap_jdk][:checksum] ="eeec:jdk93e01001e9cc651e3455030a1469"
default[:openjdk][:jdk9][:bootstrap_jdk][:sub_dir] ="jdk1.8.0"

default[:openjdk][:jdk9][:build_log_file] = "#{node[:openjdk][:jdk9][:source_tl]}/build/linux-#{node[:machine][:arch]}-normal-server-release/build.log"


