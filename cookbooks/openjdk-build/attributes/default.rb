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
default[:openjdk][:repo] = "jdk8_tl"
default[:openjdk][:home] = "/home/#{node[:user]}"
default[:openjdk][:dir] = "#{node[:openjdk][:home]}"
default[:openjdk][:forest] = "#{node[:openjdk][:dir]}/hgforest"
default[:openjdk][:source] = "#{node[:openjdk][:dir]}/source"
default[:openjdk][:source_tl] = "#{node[:openjdk][:source]}/#{node[:openjdk][:repo]}"
default[:openjdk][:source_url] = "http://hg.openjdk.java.net/jdk8/tl"
default[:openjdk][:forest_url] = "https://bitbucket.org/pmezard/hgforest-crew/overview/"
default[:openjdk][:hgrc] = "#{node[:openjdk][:home]}/.hgrc"
default[:openjdk][:get_source] = "#{node[:openjdk][:source_tl]}/get_source.sh"

#download and configre jtreg
default[:openjdk][:jtreg][:dir] = "#{node[:openjdk][:dir]}/jtreg"
default[:openjdk][:jtreg][:file] = "#{node[:openjdk][:dir]}/jtreg.tar.gz" 
default[:openjdk][:jtreg][:url] = "https://adopt-openjdk.ci.cloudbees.com/job/jtreg/lastSuccessfulBuild/artifact/jtreg-5.0.0-SNAPSHOT.tar.gz"
default[:openjdk][:jtreg][:checksum] ="2ccacd2550f8094f0dcd1601748add3e"
default[:openjdk][:product_home] = "#{node[:openjdk][:source_tl]}/build/linux-#{node[:machine][:arch]}-normal-server-release/images/j2sdk-image/"
default[:openjdk][:export_path] = "/etc/profile.d/openjdk_build_path.sh"
