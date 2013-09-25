#
# Cookbook Name:: nlesc-jenkins
# Recipe:: node
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

# Use same username for server and node
node.override['jenkins']['node']['user'] = "jenkins"
node.override['jenkins']['node']['group'] = "jenkins"

include_recipe "nlesc-base"
include_recipe "build-essential"
include_recipe "jenkins::node"
include_recipe "nlesc-jenkins::github"
include_recipe "nlesc-jenkins::octopus"
include_recipe "nodejs::npm"
include_recipe "python"
include_recipe "cmake"
include_recipe "rvm::ruby_193"
include_recipe "ant"
include_recipe "maven"

gem_package "jsduck"
npm_package "jshint"
npm_package "karma"
package "lcov"

python_pip "flake8"
python_pip "clonedigger"

# Default to display on port 99
include_recipe "xvfb"
  
