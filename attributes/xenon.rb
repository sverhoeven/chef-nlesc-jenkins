#
# Cookbook Name:: nlesc-jenkins
# Attribute:: xenon
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
config = {}

# The test.*.user and test.*.password are taken from octopus/user databag.
# SSH 
config['test.ssh.location'] = String.new
config['test.ssh.gateway'] = String.new
# Gridengine
config['test.gridengine.location'] = String.new
config['test.gridengine.default.queue'] = 'all.q'
config['test.gridengine.queues'] = 'all.q'
config['test.gridengine.queue.wait.time'] = 60000
config['test.gridengine.update.time'] = 60000
# Slurm
config['test.slurm.location'] = String.new
config['test.slurm.default.queue'] = String.new
config['test.slurm.queues'] = String.new
config['test.slurm.queue.wait.time'] = 4000
config['test.slurm.update.time'] = 10000

default['nlesc-jenkins']['xenon']['config'] = config

# The java ssh client jsch can't use hashed known hosts entries.
# The jsch library is used by octopus
# So disable hashing of known hosts.
default['openssh']['client']['hash_known_hosts'] = :no
# Octopus is be able to login to any other host with this recipe and must not be blocked by known hosts acceptance question
default['openssh']['client']['strict_host_key_checking'] = 'no'

