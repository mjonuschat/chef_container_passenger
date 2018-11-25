#
# Cookbook:: container_passenger
# Recipe:: prepare
#
# Copyright:: 2018, Morton Jonuschat <m.jonuschat@mojocode.de>
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

## Ensure documentation files are not being installed.
cookbook_file '/etc/dpkg/dpkg.cfg.d/01_nodoc' do
  source 'dpkg/dpkg-nodocs.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

## Ensure only selected locales are being installed.
cookbook_file '/etc/dpkg/dpkg.cfg.d/01_valid_locales' do
  source 'dpkg/dpkg-valid-locales.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

## Create a user for the web app.
group 'app' do
  gid 9999
end

user 'app' do
  uid 9999
  gid 9999
  password '!'
  comment 'Application'
  home '/home/app'
end

directory '/home/app' do
  owner 'app'
  group 'app'
  mode '0755'
  action :create
end

directory '/home/app/.ssh' do
  owner 'app'
  group 'app'
  mode '0700'
  action :create
end
