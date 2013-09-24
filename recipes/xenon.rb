#
# Cookbook Name:: nlesc-jenkins
# Recipe:: xenon
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

u = Chef::EncryptedDataBagItem.load('xenon', 'user')
user_name = u['name']
home_dir = "/home/#{user_name}"

group user_name

user user_name do
  password u['password_hash']
  supports :manage_home => true
  comment "Xenon test user"
  home home_dir
end

directory "#{home_dir}/.ssh" do
  owner user_name
  group user_name
  mode 0600
  action :create
end

template "#{home_dir}/.ssh/authorized_keys" do
  source "authorized_keys.erb"
  owner user_name
  group user_name
  mode 0700
  variables :ssh_keys => u['ssh_keys']
end

key_type = u['ssh_private_key'].include?("BEGIN RSA PRIVATE KEY") ? "rsa" : "dsa"
template "#{home_dir}/.ssh/id_#{key_type}" do
  source "private_key.erb"
  owner user_name
  group user_name
  mode 0400
  variables :private_key => u['ssh_private_key']
end

key_type = u['ssh_public_key'].include?("ssh-rsa") ? "rsa" : "dsa"
template "#{home_dir}/.ssh/id_#{key_type}.pub" do
  source "public_key.pub.erb"
  owner user_name
  group user_name
  mode 0400
  variables :public_key => u['ssh_public_key']
end

template "#{home_dir}/test.properties" do
  source "xenon_config.erb"
  owner user_name
  group user_name
  variables(
    :user => user_name,
    :password => u['password'],
    :config => node['xenon']['config']
  )
end

