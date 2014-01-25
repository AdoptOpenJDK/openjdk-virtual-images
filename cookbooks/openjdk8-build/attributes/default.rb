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
default[:openjdk8][:repo] = "jdk8_tl"
default[:openjdk8][:home] = "/home/#{node[:user]}"
default[:openjdk8][:dir] = "#{node[:openjdk8][:home]}"
default[:openjdk8][:forest] = "#{node[:openjdk8][:dir]}/hgforest"
default[:openjdk8][:workspace] = "#{node[:openjdk8][:dir]}/workspace"
default[:openjdk8][:source_tl] = "#{node[:openjdk8][:workspace]}/#{node[:openjdk8][:repo]}"
default[:openjdk8][:source_url] = "http://hg.openjdk.java.net/jdk8/tl"
default[:openjdk8][:forest_url] = "https://bitbucket.org/pmezard/hgforest-crew/overview/"
default[:openjdk8][:hgrc] = "#{node[:openjdk8][:home]}/.hgrc"
default[:openjdk8][:get_source] = "#{node[:openjdk8][:source_tl]}/get_source.sh"

#download and configure jtreg
default[:openjdk8][:jtreg][:dir] = "#{node[:openjdk8][:dir]}/jtreg"
default[:openjdk8][:jtreg][:file] = "#{node[:openjdk8][:dir]}/jtreg.tar.gz" 
default[:openjdk8][:jtreg][:url] = "https://adopt-openjdk.ci.cloudbees.com/job/jtreg/lastSuccessfulBuild/artifact/jtreg-4.2.0-SNAPSHOT.tar.gz"
default[:openjdk8][:jtreg][:checksum] ="2ccacd2550f8094f0dcd1601748add3e"
default[:openjdk8][:product_home] = "#{node[:openjdk8][:source_tl]}/build/linux-#{node[:machine][:arch]}-normal-server-release/images/j2sdk-image/"
default[:openjdk8][:export_path] = "/etc/profile.d/openjdk_build_path.sh"

default[:openjdk8][:build_log_file] = "#{node[:openjdk8][:source_tl]}/build/linux-#{node[:machine][:arch]}-normal-server-release/build.log"
