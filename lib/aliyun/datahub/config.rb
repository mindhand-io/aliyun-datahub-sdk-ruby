# frozen_string_literal: true

module Aliyun
  module Datahub
    # A place to store various configurations: credentials, api
    # timeout, retry mechanism, etc
    class Config < Common::Struct::Base
      attrs :access_key_id, :access_key_secret, :endpoint, :sts_token

      def initialize(opts = {})
        super(opts)

        @access_key_id = @access_key_id.strip if @access_key_id
        @access_key_secret = @access_key_secret.strip if @access_key_secret
        normalize_endpoint if @endpoint
      end

      private

      def normalize_endpoint
        uri = URI.parse(endpoint)
        uri = URI.parse("https://#{endpoint}") unless uri.scheme

        if (uri.scheme != 'http') && (uri.scheme != 'https')
          raise Datahub::ClientError, 'Only HTTP and HTTPS endpoint are accepted.'
        end

        @endpoint = uri
      end
    end # Config
  end # STS
end # Aliyun
