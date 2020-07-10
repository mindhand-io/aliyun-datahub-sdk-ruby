# frozen_string_literal: true

require 'openssl'
require 'base64'
require 'uri'
require 'typhoeus'
require 'oj'

module Aliyun
  module Datahub
    class Http
      include Common::Logging

      STS_HEADER = 'x-datahub-security-token'
      API_VERSION = '1.1'
      DEFAULT_ACCEPT_ENCODING = nil
      CONN_TIMEOUT = 5
      READ_TIMEOUT = 120
      RETRY_TIMES = 3

      def initialize(config)
        @config = config
      end

      def send_request(verb, path, body = {}, headers = {})
        sig_params = {}
        sig_params['verb'] = verb.to_s
        sig_params['content-type'] = headers['Content-Type']
        sig_params['resource'] = path
        sig_params['date'] = Time.now.httpdate
        sig_params['request-action'] =headers['x-datahub-request-action']

        headers['user-agent'] = 'datahub-ruby-official-sdk'
        headers['accept-encoding'] ||= DEFAULT_ACCEPT_ENCODING
        headers['x-datahub-client-version'] = API_VERSION
        headers[STS_HEADER] = @config.sts_token if @config.sts_token
        headers['Date'] = sig_params['date']
        headers['Authorization'] = signature(sig_params)

        uri = URI(@config.endpoint + path)
        is_post = %i[post put].include? verb
        req = Typhoeus::Request.new(uri, method: verb,
                                         body: (is_post ? Oj.dump(body, mode: :compat) : nil),
                                         headers: headers
                                    )
        req.on_complete do |resp|
          unless [200, 201].include?(resp.code)
            raise Datahub::ServerError, 'Send request failed, unknown response.' if resp.body.empty?

            raise Datahub::ServerError, resp.body
          end
          result = resp.body
          return true if result.empty?

          return result
        end
        req.run
      end

      def signature(params)
        verb = params['verb']
        content_type = params['content-type']
        resource = params['resource']
        gmt_time = params['date']
        request_action = "x-datahub-request-action:#{params['request-action']}\n" unless params['request-action'].nil?
        datahub_headers = "x-datahub-client-version:#{API_VERSION}\n#{request_action}"
        data = verb.upcase + "\n" + content_type + "\n" + gmt_time + "\n" + datahub_headers + resource
        # data = "GET\napplication/json\nFri, 06 May 2016 06:43:31 GMT\nx-datahub-client-version:1.1\n/projects/test_project/topics/datahub_fluentd_out_1"
        'DATAHUB ' + @config.access_key_id + ':' +
          Base64.encode64(OpenSSL::HMAC.digest('sha1', @config.access_key_secret, data).to_s).chomp
      end
    end
  end
end
