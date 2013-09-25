#
# Cookbook Name:: nlesc-jenkins
# Recipe:: github
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

ohai "reload_passwd" do
    plugin "passwd"
end

user_name = node['nlesc-jenkins']['github']['user']
group_name = node['nlesc-jenkins']['github']['group']
# for this to work the user must exist
home_dir = node[:etc][:passwd][user_name][:dir]
#home_dir = "/home/#{user_name}"

directory "#{home_dir}/.ssh" do
  owner user_name
  group group_name
  mode 0600
  action :create
end

ssh_known_hosts "github.com" do
  hashed false
  user user_name
end

u = Chef::EncryptedDataBagItem.load('github', 'user')

template "#{home_dir}/.ssh/github.key" do
  source "private_key.erb"
  owner user_name
  group group_name
  mode 0400
  variables :private_key => u['ssh_private_key']
end

ssh_config "github.com" do
  options 'User' => 'git', 'IdentityFile' => "#{home_dir}/.ssh/github.key"
  user user_name
end

template "#{home_dir}/.ssh/github.pub" do
  source "public_key.erb"
  owner user_name
  group group_name
  mode 0400
  variables :public_key => u['ssh_public_key']
end

