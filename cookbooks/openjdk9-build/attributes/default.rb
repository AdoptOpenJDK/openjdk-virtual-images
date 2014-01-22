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
# constants for building OpenJdk.
default[:user] = "openjdk"
default[:owner] = "root"
default[:machine][:arch] = kernel['machine']
default[:openjdk9][:repo] = "jdk9"
default[:openjdk9][:home] = "/home/#{node[:user]}"
default[:openjdk9][:dir] = "#{node[:openjdk9][:home]}"
default[:openjdk9][:forest] = "#{node[:openjdk9][:dir]}/hgforest"
default[:openjdk9][:workspace] = "#{node[:openjdk9][:dir]}/workspace"
default[:openjdk9][:source_tl] = "#{node[:openjdk9][:workspace]}/#{node[:openjdk9][:repo]}"
default[:openjdk9][:source_url] = "http://hg.openjdk.java.net/jdk9/jdk9"
default[:openjdk9][:forest_url] = "https://bitbucket.org/pmezard/hgforest-crew/overview/"
default[:openjdk9][:hgrc] = "#{node[:openjdk9][:home]}/.hgrc"
default[:openjdk9][:get_source] = "#{node[:openjdk9][:source_tl]}/get_source.sh"

#download and configure jtreg
default[:openjdk9][:jtreg][:dir] = "#{node[:openjdk9][:dir]}/jtreg"
default[:openjdk9][:jtreg][:file] = "#{node[:openjdk9][:dir]}/jtreg.tar.gz" 
default[:openjdk9][:jtreg][:url] = "https://adopt-openjdk.ci.cloudbees.com/job/jtreg/lastSuccessfulBuild/artifact/jtreg-4.2.0-SNAPSHOT.tar.gz"
default[:openjdk9][:jtreg][:checksum] ="2ccacd2550f8094f0dcd1601748add3e"
default[:openjdk9][:product_home] = "#{node[:openjdk9][:source_tl]}/build/linux-#{node[:machine][:arch]}-normal-server-release/images/j2sdk-image/"
default[:openjdk9][:export_path] = "/etc/profile.d/openjdk_build_path.sh"

#download jdk8ea and install into /usr/lib/jdk1.8.0
default[:openjdk9][:jdk8ea][:dir] = "#{node[:openjdk9][:home]}"
default[:openjdk9][:jdk8ea][:file] = "#{node[:openjdk9][:home]}/jdk-8-ea-b123.tar.gz" 
default[:openjdk9][:jdk8ea][:url] = "http://www.java.net/download/jdk8/archive/b123/binaries/jdk-8-ea-bin-b123-linux-x64-10_jan_2014.tar.gz"
default[:openjdk9][:jdk8ea][:checksum] ="eeec93e01001e9cc651e3455030a1469"

default[:openjdk9][:build_folder] = "#{node[:openjdk9][:source_tl]}/build"