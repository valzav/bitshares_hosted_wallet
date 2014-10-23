require 'net/http'
require 'uri'
require 'json'

module BitShares
  class API

    @@rpc_instance = nil

    def self.init(port, username, password, options = nil)
      options ||= { ignore_errors: false }
      @@rpc_instance = BitShares::API::Rpc.new(port, username, password, options)
    end

    def self.rpc
      @@rpc_instance
    end

    class Wallet
      def self.method_missing(name, *params)
        BitShares::API::rpc.request("wallet_" + name.to_s, params)
      end
    end

    class Network
      def self.method_missing(name, *params)
        BitShares::API::rpc.request("network_" + name.to_s, params)
      end
    end

    class Blockchain
      def self.method_missing(name, *params)
        BitShares::API::rpc.request("blockchain_" + name.to_s, params)
      end
    end

    class Misc
      def self.method_missing(name, *params)
        BitShares::API::rpc.request(name.to_s, params)
      end
    end

    class Rpc

      class Error < RuntimeError; end

      def initialize(port, username, password, options)
        @uri = URI("http://localhost:#{port}/rpc")
        @req = Net::HTTP::Post.new(@uri)
        @req.content_type = 'application/json'
        @req.basic_auth username, password
        @options = options
      end

      def request(method, params = nil)
        params = params || []
        puts "+ request: #{method} #{params.join(' ')}"
        result = nil
        Net::HTTP.start(@uri.hostname, @uri.port) do |http|
          @req.body = { method: method, params: params, id: 0 }.to_json
          response = http.request(@req)
          result = JSON.parse(response.body)
          if result['error']
            if !@options[:ignore_errors]
              raise Error, result['error']
            else
              STDERR.puts "Error: #{result['error']}\n"
            end
          else
            puts '- ok'
          end
        end
        return result['result']
      end

      def request_raw(method, params)
        response = nil
        Net::HTTP.start(@uri.hostname, @uri.port) do |http|
          @req.body = { method: method, params: params || [], id: 0 }.to_json
          response = http.request(@req)
        end
        response.body
      end

    end

  end

end

 
if $0 == __FILE__
  puts "BitShares API test.."
  BitShares::API.init(5680, 'user', 'pass')
  accounts = BitShares::API::Wallet.list_my_accounts()
  first_account = accounts[0]['name']
  puts BitShares::API::Wallet.account_transaction_history(first_account)
  puts BitShares::API::Wallet.market_order_list("USD", "BTSX")
  puts BitShares::API::Blockchain.list_assets("USD", 1)
end
