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

default[:openjdk][:dir] = "/home/vagrant/openjdk/"
default[:openjdk][:forest] = "#{node[:openjdk][:dir]}hgforest/"
default[:openjdk][:source] = "#{node[:openjdk][:dir]}source/"
default[:openjdk][:source_url] = "http://hg.openjdk.java.net/jdk8/tl"
default[:openjdk][:forest_url] = "https://bitbucket.org/pmezard/hgforest-crew/overview/"
default[:openjdk][:get_source] = "#{node[:openjdk][:source]}get_source.sh"
