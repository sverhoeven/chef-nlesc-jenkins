#
# Cookbook Name:: nlesc-jenkins
# Recipe:: rdkit
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

include_recipe "build-essential"
include_recipe "xml"
include_recipe "boost"

package "bison"
package "flex"

folder = node['nlesc-jenkins']['rdkit']['folder']
version = node['nlesc-jenkins']['rdkit']['version']

remote_file "#{Chef::Config[:file_cache_path]}/RDKit_#{version}.tgz" do
  source "http://downloads.sourceforge.net/project/rdkit/rdkit/#{folder}/RDKit_#{version}.tgz"
end

home = '/opt/rdkit'

python_virtualenv home do
  action :create
end

python_pip "numpy" do
  virtualenv home
end

bash "build php" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  tar -zxvf RDKit-#{version}.tgz
  (cd RDKit-#{version}/External/INCHI-API && . download_inchi.sh)
  (cd RDKit-#{version} && mkdir build)
  (cd RDKit-#{version}/build && . #{home}/bin/activate && cmake -DRDK_BUILD_INCHI_SUPPORT=ON -D PYTHON_LIBRARY=#{home}/lib/python2.7/config/libpython2.7-pic.a -D PYTHON_INCLUDE_DIR=#{home}/include/python2.7 -D PYTHON_EXECUTABLE=#{home}/bin/python  ..) 
  (cd RDKit-#{version} && . #{home}/bin/activate && make)
  EOF
end
