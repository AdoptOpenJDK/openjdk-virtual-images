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
default[:openjdk][:home] = "/home/vagrant/"
default[:openjdk][:dir] = "#{node[:openjdk][:home]}openjdk/"
default[:openjdk][:forest] = "#{node[:openjdk][:dir]}hgforest/"
default[:openjdk][:source] = "#{node[:openjdk][:dir]}source/"
default[:openjdk][:source_url] = "http://hg.openjdk.java.net/jdk8/tl"
default[:openjdk][:forest_url] = "https://bitbucket.org/pmezard/hgforest-crew/overview/"
default[:openjdk][:hgrc] = "#{node[:openjdk][:home]}.hgrc"
default[:openjdk][:get_source] = "#{node[:openjdk][:source]}get_source.sh"

#download and configre jtreg
default[:openjdk][:jtreg][:dir] = "#{node[:openjdk][:dir]}jtreg/"
default[:openjdk][:jtreg][:file] = "#{node[:openjdk][:jtreg][:dir]}jtreg-4.1.zip" 
default[:openjdk][:jtreg][:url] = "http://www.java.net/download/openjdk/jtreg/promoted/4.1/b05/jtreg-4.1-src-b05_29_nov_2012.zip"
default[:openjdk][:jtreg][:checksum] ="2ccacd2550f8094f0dcd1601748add3e"
default[:openjdk][:product_home] = "#{node[:openjdk][:source]}build/linux-x64-normal-server-release/images/j2sdk-image/"
default[:openjdk][:export_path] = "/etc/profile.d/openjdk_build_path.sh"
