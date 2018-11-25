#
# Cookbook:: container_passenger
# Recipe:: repositories
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

## PostgreSQL Global Development Group (PGDG)repository
apt_repository 'pgdg' do
  uri 'http://apt.postgresql.org/pub/repos/apt/'
  key 'ACCC4CF8'
  distribution "#{node['lsb']['codename']}-pgdg"
  components %w[main]
end

## Phusion Passenger repository
apt_repository 'passenger' do
  uri 'https://oss-binaries.phusionpassenger.com/apt/passenger'
  key '561F9B9CAC40B2F7'
  components %w[main]
end

## Nodesource Node.js repository
apt_repository 'nodesource' do
  uri "https://deb.nodesource.com/#{node['container_passenger']['node']['version']}"
  key 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
  components %w[main]
end

## Yarn repository
apt_repository 'yarn' do
  uri 'https://dl.yarnpkg.com/debian/'
  distribution 'stable'
  key 'https://dl.yarnpkg.com/debian/pubkey.gpg'
  components %w[main]
end

## Rowan's Redis PPA repository
apt_repository 'redis' do
  uri 'http://ppa.launchpad.net/chris-lea/redis-server/ubuntu'
  key 'C7917B12'
  components %w[main]
end

## OpenJDK 8 PPA repository
apt_repository 'openjdk' do
  uri 'http://ppa.launchpad.net/openjdk-r/ppa/ubuntu'
  key 'DA1A4A13543B466853BAF164EB9B1D8886F44E2A'
  components %w[main]
end

## RVM PPA repository
apt_repository 'rvm' do
  uri 'http://ppa.launchpad.net/rael-gc/rvm/ubuntu'
  key '7BE3E5681146FD4F1A40EDA28094BB14F4E3FBBE'
  components %w[main]
end

## nginx: C300EE8C

## Update apt repository information
apt_update 'refresh' do
  action :update
end
