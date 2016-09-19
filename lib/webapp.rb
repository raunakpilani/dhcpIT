require 'sinatra/base'
require 'json'
$LOAD_PATH << '.'
require 'dhcp.rb'
require 'dhcp/log.rb'
require 'dhcp/server/isc.rb'

class WebApp < Sinatra::Base

  def self.run!
    opts = {
      :name => "127.0.0.1",
      :config => "/etc/dhcp/dhcpd.conf",
      :leases => "/var/lib/dhcpd/dhcpd.leases"
    }
    set :dchp_server, DHCP::ISC.new(opts)
    set :subnets, settings.dhcp_server.subnets
    super
  end

  get '/' do
    "dragons have capricious parents"
  end

  get '/subnets' do
    subs = settings.subnets.map(&:to_s)
    content_type :json
    subs.to_json
  end

  get '/counts' do
    counts = {}
    settings.subnets.each {|sub| counts[sub.to_s] = sub.record_count}
    content_type :json
    counts.to_json
  end

  get '/records' do
    records = {}
    settings.subnets.each {|sub| records[sub] = sub.records}
    content_type :json
    records.to_json
  end

  get '/unload' do
    settings.dhcp_server.unloadSubnets
    "unloaded"
  end

  run! if app_file == $0

end
