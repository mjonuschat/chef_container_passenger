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

include_recipe 'container_passenger::repositories'
include_recipe 'container_passenger::prepare'
include_recipe 'container_passenger::utilities'
include_recipe 'container_passenger::ruby'
include_recipe 'container_passenger::python'
include_recipe 'container_passenger::nodejs'
include_recipe 'container_passenger::passenger'
include_recipe 'container_passenger::finalize'
