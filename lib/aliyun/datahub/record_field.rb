# frozen_string_literal: true

require 'oj'
module Aliyun
  module Datahub
    class RecordField
      attr_reader :name, :type

      def initialize(name, type)
        @name = name
        @type = type
      end

      def to_json(options = {mode: :compat})
        field_map = {}
        field_map['name'] = @name
        field_map['type'] = @type
        Oj.dump(field_map, options)
      end
    end
  end
end
