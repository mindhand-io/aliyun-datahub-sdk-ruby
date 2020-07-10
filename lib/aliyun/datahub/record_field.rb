# frozen_string_literal: true

require 'oj'
module Aliyun
  module Datahub
    class RecordField
      attr_reader :name, :type

      ALLOWED_TYPES = %w[STRING BIGINT DOUBLE TIMESTAMP BOOLEAN DECIMAL].freeze
      def initialize(name, type)
        @name = name

        raise ArgumentError, 'Invalid RecordField Type' unless ALLOWED_TYPES.include?(type)

        @type = type
      end

      def to_json(options = {})
        field_map = {}
        field_map['name'] = @name
        field_map['type'] = @type
        Oj.dump(field_map, options)
      end
    end
  end
end
