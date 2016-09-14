module DHCP;
  require 'sinatra/base'
  require 'dhcp/log'
  require 'dhcp/server/isc'
  class WebApp < Sinatra::Base

    def self.run!
      @server=DHCP::ISC.new(opts)
      @subnets = @server.subnets
      super
    end

    get '/' do
      "dragons have capricious parents"
    end

    get '/subnets' do
      @subnets.to_json
    end

    get '/counts' do
      counts = {}
      @subnets.each {|sub| counts[sub.to_s] = sub.record_counts}
      counts.to_json
    end

    get '/records' do
      records = {}
      @subnets.each {|sub| @records[sub] = sub.records}
      records.to_json
    end

    get '/unload' do
      @server.unloadSubnets
    end
    run! if app_file == $0
  end
end
