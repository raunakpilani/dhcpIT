$LOAD_PATH << "#{Dir.pwd}/lib" # Dirty hack

require 'dhcp'
require 'test/unit'
require 'yaml'

module TestConfig
  SETTINGS    = ::YAML.load_file('test/test_config.yml')

  SERVER      = SETTINGS['server']['address']
  CONF_FILE   = SETTINGS['server']['config']
  LEASE_FILE  = SETTINGS['server']['leases']

  SUBNET      = SETTINGS['network']['subnet']

  NET_TESTS   = SETTINGS['tests']['ping']
end