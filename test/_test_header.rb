$LOAD_PATH << "#{Dir.pwd}/lib" # Dirty hack

require 'dhcp'
require 'test/unit'

module TestConfig
  SETTINGS    = YAML.load_file('test/test_config.yaml')

  SERVER      = SETTINGS['dhcp']['server']
  CONF_FILE   = SETTINGS['dhcp']['config']
  LEASE_FILE  = SETTINGS['dhcp']['lease']
end