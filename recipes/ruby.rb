#
# Cookbook:: container_passenger
# Recipe:: ruby
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

return unless node['container_passenger']['ruby']['enabled']

package 'rvm' do
  action :upgrade
end

file '/etc/gemrc' do
  content 'gem: --no-document'
  owner 'root'
  group 'root'
  mode '0644'
end

file '/etc/profile.d/rvm_secure_path.sh' do
  content 'rvmsudo_secure_path=1'
  owner 'root'
  group 'root'
  mode '0755'
end

file '/etc/profile.d/rvm_silence_path_warning.sh' do
  content 'rvm_silence_path_mismatch_check_flag=1'
  owner 'root'
  group 'root'
  mode '0755'
end

group 'rvm' do
  members %w[app]
  action :create
end

cookbook_file '/usr/bin/rvm-exec' do
  source 'rvm/system-rvm-exec.sh'
  owner 'root'
  group 'root'
  mode '0755'
end

cookbook_file "#{Chef::Config[:file_cache_path]}/ruby-fake_1.0.0_all.deb" do
  source 'dpkg/ruby-fake_1.0.0_all.deb'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :upgrade, 'dpkg_package[ruby-fake]', :immediately
end

dpkg_package 'ruby-fake' do
  source "#{Chef::Config[:file_cache_path]}/ruby-fake_1.0.0_all.deb"
  action :nothing
end

node['container_passenger']['ruby']['versions'].to_a.each do |version|
  major_version = Gem::Version.new(version).segments[0,2].join('.')

  execute "rvm-install-ruby-#{version}" do
    command "/usr/share/rvm/bin/rvm install ruby-#{version}"
    creates "/usr/share/rvm/rubies/ruby-#{version}/bin/ruby"
    action :run
    notifies :create, "template[rvm-create-ruby-wrapper-#{version}]", :immediately
    notifies :run, "execute[install-default-ruby-gems-#{version}]", :immediately
  end

  execute "install-default-ruby-gems-#{version}" do
    command "/usr/share/rvm/bin/rvm-exec #{version}@global gem install #{node['container_passenger']['ruby']['default_gems'].join(' ')} --no-document"
    action :nothing
  end

  template "rvm-create-ruby-wrapper-#{version}" do
    path "/usr/bin/ruby#{major_version}"
    source 'rvm-wrapper.erb'
    variables(version: "ruby-#{version}", command: "ruby")
    owner 'root'
    group 'root'
    mode '0755'
    action :nothing
  end

  file "/usr/share/rvm/rubies/ruby-#{version}/lib/libruby-static.a" do
    action :delete
  end
end

## The Rails asset compiler requires a Javascript runtime.
package %w[nodejs yarn] do
  action :upgrade
end

## Install development headers for native libraries that tend to be used often by Ruby gems.
package %w[libxml2-dev libxslt1-dev libmysqlclient-dev libpq-dev zlib1g-dev] do
  action :upgrade
end

## Set the latest version as default
default_ruby_version = node['container_passenger']['ruby']['versions'].sort_by { |v| Gem::Version.new(v) }.last
execute 'rvm-set-default-ruby' do
  command "bash -lc 'rvm use #{default_ruby_version} --default'"
end

## Create default wrappers for common gems
%w[ruby gem rake bundle bundler].each do |name|
  template "rvm-create-#{name}-default-wrapper" do
    path "/usr/bin/#{name}"
    source 'rvm-wrapper.erb'
    variables(version: 'default', command: name)
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end
