#
# Cookbook Name:: nlesc-jenkins
# Recipe:: senchacmd
#
# Copyright (C) 2013 Netherlands eScience Center
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

version = node['nlesc-jenkins']['senchacmd']['version']

remote_file "#{Chef::Config[:file_cache_path]}/SenchaCmd-#{version}-linux-x64.run.zip" do
  source "http://cdn.sencha.com/cmd/beta/#{version}/SenchaCmd-#{version}-linux-x64.run.zip"
end

package "unzip"

execute "unzip" do
  command "unzip SenchaCmd-#{version}-linux-x64.run.zip"
  cwd Chef::Config[:file_cache_path]
end

execute "executable installer" do
  command "/bin/chmod u+x SenchaCmd-#{version}-linux-x64.run"
  cwd Chef::Config[:file_cache_path]
end

prefix = node['nlesc-jenkins']['senchacmd']['prefix']

execute "install" do
  command "./SenchaCmd-#{version}-linux-x64.run --prefix #{prefix} --mode unattended"
  cwd Chef::Config[:file_cache_path]
end
