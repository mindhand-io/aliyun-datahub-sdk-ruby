# frozen_string_literal: true

require 'nokogiri'

module Aliyun
  module Datahub
    class ServerError < Common::Exception
    end # ClientError

    ##
    # ClientError represents client exceptions caused mostly by
    # invalid parameters.
    #
    class ClientError < Common::Exception
    end # ClientError

  end
end
