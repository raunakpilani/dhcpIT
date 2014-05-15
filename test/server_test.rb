$: << '../foreman/vendor/rails/activesupport/lib/'
$: << '../foreman/vendor/rails/activesupport/lib/active_support/vendor/memcache-client-1.7.4'
$: << '../foreman/vendor/rails/activesupport/lib/active_support/vendor/builder-2.1.2'
require 'active_support/core_ext'
require 'active_support/cache'

require_relative '_test_header'

class DHCPServerTest < Test::Unit::TestCase

  def setup
    @server = DHCP::Server.new(TestConfig::SERVER_NAME)
    @subnet = DHCP::Subnet.new(@server, TestConfig::SUBNET, TestConfig::SUBNET_MASK)
    @record = DHCP::Record.new(@subnet, TestConfig::TEST_ADDR, TestConfig::TEST_HWADDR)
  end

  def test_should_provide_subnets
    assert_respond_to @server, :subnets
  end

  def test_should_add_subnet
    counter = @server.subnets.count
    DHCP::Subnet.new(@server, TestConfig::SUBNET_2, TestConfig::SUBNET_MASK)
    assert_equal counter+1, @server.subnets.count
  end

  def test_should_not_add_duplicate_subnets
    assert_raise DHCP::Error do
      DHCP::Subnet.new(@server, TestConfig::SUBNET, TestConfig::SUBNET_MASK)
    end
  end

  def test_should_find_subnet_based_on_network
    assert_equal @subnet, @server.find_subnet(TestConfig::SUBNET)
  end

  def test_should_find_subnet_based_on_dhcp_record
    assert_equal @subnet, @server.find_subnet(@record)
  end

  def test_should_find_subnet_based_on_ipaddr
    ip = IPAddr.new TestConfig::TEST_ADDR
    assert_equal @subnet, @server.find_subnet(ip)
  end

  def test_should_find_record_based_on_ip
    assert_equal @record, @server.find_record(TestConfig::TEST_ADDR)
  end

  def test_should_find_record_based_on_dhcp_record
    assert_equal @record, @server.find_record(@record)
  end

  def test_should_find_record_based_on_ipaddr
    ip = IPAddr.new TestConfig::TEST_ADDR
    assert_equal @record, @server.find_record(ip)
  end

  def test_should_return_nil_when_no_subnet
    subnet = @server.find_subnet IPAddr.new TestConfig::BAD_ADDRESS
    assert_nil subnet
  end

  def test_should_have_a_name
    assert !@server.name.nil?
  end

  def test_should_find_global_subnet
    @server2 = DHCP::Server.new("#{TestConfig::SERVER_NAME}_2")
    @subnet2 = DHCP::Subnet.new(@server, TestConfig::SUBNET_2, TestConfig::SUBNET_MASK)

    net1 = DHCP::Server[TestConfig::SUBNET]
    net2 = DHCP::Server[TestConfig::SUBNET_2]
    assert_kind_of DHCP::Subnet, net1
    assert_kind_of DHCP::Subnet, net2
    assert net1 != net2
  end

  def test_should_support_caching
    return unless TestConfig::DALLI_TESTS

    cache = ActiveSupport::Cache::MemCacheStore.new 'localhost'
    cache.clear
    cache.write('servers', @server)
    @recovered = cache.fetch('servers')
    assert_equal @subnet[TestConfig::TEST_ADDR].mac, @recovered.find_subnet(TestConfig::SUBNET)[TestConfig::TEST_ADDR].mac
  end
end
