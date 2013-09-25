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
include_recipe "cmake"
include_recipe "boost"
include_recipe "python"
package "libboost-python-dev"
package "libboost-regex-dev"
package "bison"
package "flex"

folder = node['nlesc-jenkins']['rdkit']['folder']
version = node['nlesc-jenkins']['rdkit']['version']
prefix = node['nlesc-jenkins']['rdkit']['prefix']

python_virtualenv prefix do
  action :create
end

# Don't want system numpy, but a fresh install
python_pip "numpy" do
  virtualenv prefix
end

remote_file "#{prefix}/RDKit_#{version}.tgz" do
  source "http://downloads.sourceforge.net/project/rdkit/rdkit/#{folder}/RDKit_#{version}.tgz"
end

directory "#{prefix}/build"

log "Compiling RDKit, please wait..."

bash "build rdkit" do
  cwd prefix
  code <<-EOF
  . bin/activate
  tar -zxkf RDKit_#{version}.tgz
  mv -n RDKit_#{version}/* .
  cd External/INCHI-API
  . download-inchi.sh
  cd ../../build
  cmake -DRDK_BUILD_INCHI_SUPPORT=ON -D PYTHON_LIBRARY=../lib/python2.7/config/libpython2.7-pic.a -D PYTHON_INCLUDE_DIR=../include/python2.7 -D PYTHON_EXECUTABLE=../bin/python ..
  make
  make install
  mv rdkit lib/python2.7/site-packages/
  EOF
  not_if { ::File.exists?("#{prefix}/lib/python2.7/site-packages/rdkit/rdBase.so") }
end

# TODO add /opt/rdkit/lib to ldconfig
