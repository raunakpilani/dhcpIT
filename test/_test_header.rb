$LOAD_PATH << "#{Dir.pwd}/lib" # Dirty hack

require 'dhcp'
require 'test/unit'
require 'yaml'
require 'logger'

@logger = Logger.new('test.log')

module TestConfig
  SETTINGS    = ::YAML.load_file('test/test_config.yml')

  SERVER_NAME = SETTINGS['server']['name']
  SERVER      = SETTINGS['server']['address']
  CONF_FILE   = SETTINGS['server']['config']
  LEASE_FILE  = SETTINGS['server']['leases']

  SUBNET      = SETTINGS['network']['subnet']
  SUBNET_2    = SETTINGS['network']['subnet2']
  SUBNET_MASK = SETTINGS['network']['subnetmask']
  TEST_ADDR   = SETTINGS['network']['record']['address']
  TEST_HWADDR = SETTINGS['network']['record']['hwaddr']
  BAD_ADDRESS = SETTINGS['network']['invalidaddr']

  NET_TESTS   = SETTINGS['tests']['ping']
  ISC_TESTS   = SETTINGS['tests']['isc']
  MS_TESTS    = SETTINGS['tests']['ms']
  DALLI_TESTS = SETTINGS['tests']['dalli']

  MS_USERPATH = SETTINGS['msdhcp']['user']
  MS_PASSWORD = SETTINGS['msdhcp']['password']
  MS_GATEWAY  = SETTINGS['msdhcp']['gateway']
  MS_SERVER   = SETTINGS['msdhcp']['server']
end