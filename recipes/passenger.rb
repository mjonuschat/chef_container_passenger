#
# Cookbook:: container_passenger
# Recipe:: passenger
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

package %w[nginx passenger libnginx-mod-http-passenger] do
  action :upgrade
end

directory '/etc/nginx/main.d' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/etc/nginx/main.d/default.conf' do
  source 'nginx/default.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

runit_service 'nginx' do
  default_logger true
  start_down true
end

runit_service 'nginx-log-forwarder' do
  log false
end

cookbook_file '/etc/logrotate.d/nginx' do
  source 'logrotate/nginx.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

if node['container_passenger']['ruby']['enabled']
  node['container_passenger']['ruby']['versions'].to_a.each do |version|
    major_version = "ruby#{Gem::Version.new(version).segments[0,2].join('.')}"

    execute "passenger-build-native-support-#{major_version}-root" do
      command "#{major_version} -S passenger-config build-native-support"
    end

    execute "passenger-build-native-support-#{major_version}-app" do
      command "setuser app #{major_version} -S passenger-config build-native-support"
    end
  end
end
