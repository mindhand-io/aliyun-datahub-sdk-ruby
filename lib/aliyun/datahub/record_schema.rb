# frozen_string_literal: true

require 'oj'

module Aliyun
  module Datahub
    class RecordSchema
      attr_reader :encoding, :message, :fields, :fields_map
      def initialize
        @fields = []
        @fields_map = {}
      end


      def add_field(field)
        return unless @fields_map[field.name].nil?

        @fields.push(field)
        @fields_map[field.name] = field
      end

      def find_field(name)
        @fields_map[name]
      end


      def to_json(options = {mode: :compat})
        tuple = {}
        tuple['fields'] = @fields
        Oj.dump(tuple, options)
      end

    end
  end
end
