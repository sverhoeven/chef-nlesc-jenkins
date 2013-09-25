#
# Cookbook Name:: nlesc-jenkins
# Recipe:: server
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

# Master should not build jobs.
node.override["jenkins"]["node"] = {
    "executors" => 1,
    "mode" => "exclusive",
    "labels" => ["master"]
}

include_recipe "nlesc-base"
include_recipe "jenkins::server"
include_recipe "jenkins::proxy"
# Allow jenkins user to clone github repos with SSH.
include_recipe "nlesc-jenkins::github"
# Allow jenkins to send mails
include_recipe "postfix"
