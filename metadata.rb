name 'container_passenger'
maintainer 'Morton Jonuschat'
maintainer_email 'm.jonuschat@mojocode.de'
license 'Apache-2.0'
description 'Configures a Docker/Rkt/LXC image for Ruby, Python, Node.js and Meteor web apps.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.0.1'

recipe 'container_passenger::default', 'Create a typical container image meant to serve as good base for Ruby, Python, Node.js and Meteor web apps.'

%w(ubuntu debian).each do |os|
  supports os
end

depends 'apt', '>= 7.1.1'
depends 'runit', '>= 4.3.0'

source_url 'https://github.com/mjonuschat/container_passenger'
issues_url 'https://github.com/mjonuschat/container_passenger/issues'
chef_version '>= 14.5' if respond_to?(:chef_version)
