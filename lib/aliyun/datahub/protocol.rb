require 'typhoeus'
require 'oj'

module Aliyun
  module Datahub
    class Protocol
      include Common::Logging

      def initialize(config)
        @config = config
        @http = Http.new(config)
      end

      # def protobuf_request(path, records)
      #   headers['Content-Type'] = 'application/x-protobuf'
      #   headers['x-datahub-request-action'] = 'pub'
      #   body = records.to_proto
      #   result = @http.send_request(:post, path, body, headers)
      # end

      def json_request(verb, path, body = {}, headers = {})
        headers['Content-Type'] = 'application/json'
        result = @http.send_request(verb, path, body, headers)
        result = Oj.safe_load(result) if result.is_a? String
        result
      end
    end
  end
end