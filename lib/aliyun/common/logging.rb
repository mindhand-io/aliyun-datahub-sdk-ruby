# frozen_string_literal: true

require 'logger'

module Aliyun
  module Common
    module Logging
      MAX_NUM_LOG = 100
      ROTATE_SIZE = 10 * 1024 * 1024

      # level = Logger::DEBUG | Logger::INFO | Logger::ERROR | Logger::FATAL
      def self.log_level=(level)
        Logging.logger.level = level
      end

      # 设置日志输出的文件
      def self.log_file=(file)
        @log_file = file
      end

      # 获取logger
      def logger
        Logging.logger
      end

      def self.logger
        unless @logger
          # Environment parameter ALIYUN_DATAHUB_SDK_LOG_PATH used to set output log to a file,do not output log if not set
          @log_file ||= ENV['ALIYUN_DATAHUB_SDK_LOG_PATH']
          @logger = Logger.new(
            @log_file, MAX_NUM_LOG, ROTATE_SIZE
          )
          @logger.level = Logger::INFO
        end
        @logger
      end
    end
  end
end
