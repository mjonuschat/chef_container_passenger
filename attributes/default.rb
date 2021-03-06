#
# Cookbook:: container_passenger
# Recipe:: default
#
# Copyright:: 2018, Morton Jonuschat <m.jonuschat@mojocode.de>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['container_passenger']['ruby']['enabled'] = false
default['container_passenger']['ruby']['versions'] = %w[2.6.2]
default['container_passenger']['jruby']['enabled'] = false
default['container_passenger']['jruby']['version'] = '9.2.6.0'
default['container_passenger']['python']['enabled'] = false
default['container_passenger']['node']['enabled'] = false
default['container_passenger']['node']['version'] = value_for_platform(
    {
        %w[ubuntu debian] => {
            '18.04' => 'node_10.x',
            'default' => 'node_12.x',
        }
    }
)

