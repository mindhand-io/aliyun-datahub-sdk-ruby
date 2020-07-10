# frozen_string_literal: true

require 'oj'

module Aliyun
  module Datahub
    class RecordEntry
      $STRING_MAX_LENGTH = 1 * 1024 * 1024
      attr_reader :columns_map, :schema

      def initialize(schema)
        @columns_map = {}

        @shard_id = '0'

        @schema = schema
        @attributes = {}
      end

      def set(name, value)
        @columns_map[name] = value
      end

      def set_shard_id(shard_id)
        (shard_id.is_a? String) ? @shard_id = shard_id : raise(ArgumentError, 'shard_id must be String type!')
      end

      def add_attribute(name, value)
        @attributes[name] = value
      end

      def set_big_int(name, value)
        if value.nil?
          set(name, value)
        elsif value.is_a? Integer
          set(name, value)
        elsif value.is_a?(String) && (value.to_i.to_s == value)
          set(name, value.to_i)
        else
          raise 'value show be Integer, name:' + name.to_s + ' value:' + value.to_s
        end
      end

      def set_double(name, value)
        if value.nil?
          set(name, value)
        elsif value.is_a? Float
          set(name, value)
        elsif value.is_a? String
          begin
            set(name, Float(value))
          rescue StandardError
            raise 'value show be Float, name:' + name.to_s + ' value:' + value.to_s
          end
        else
          raise 'value show be Float, name:' + name.to_s + ' value:' + value.to_s
        end
      end

      def set_boolean(name, value)
        if value.nil?
          set(name, value)
        elsif value.is_a? String
          if value == 'true'
            set(name, true)
          elsif value == 'false'
            set(name, false)
          else
            raise 'value must be true or false, name:' + name.to_s + ' value:' + value.to_s
          end
        elsif (value != false) && (value != true)
          raise 'value must be bool or string[true,false], name:' + name.to_s + ' value:' + value.to_s
        end
        set(name, value)
      end

      def set_timestamp(name, value)
        if value.nil?
          set(name, value)
        elsif value.is_a? Integer
          set(name, value)
        elsif value.is_a?(String) && (value.to_i.to_s == value)
          set(name, value.to_i)
        else
          raise 'value should be Integer, name:' + name.to_s + ' value:' + value.to_s
        end
      end

      def set_string(name, value)
        if value.nil?
          set(name, value)
        elsif value.is_a?(String) && (value.length < $STRING_MAX_LENGTH)
          set(name, value)
        else
          raise 'value show be String and len < ' + $STRING_MAX_LENGTH.to_s + ', name:' + name.to_s + ' value:' + value.to_s
        end
      end

      def stored_column_values
        data = []
        fields = @schema.fields
        (0...fields.size).each do |i|
          field = fields[i]
          name = field.name
          if @columns_map[name].nil?
            data.push(@columns_map[name])
          elsif data.push(@columns_map[name].to_s)
          end
        end
        data
      end

      def to_json(options = { mode: :compat })
        Oj.dump({
                  'Data' => stored_column_values,
                  'ShardId' => @shard_id,
                  'Attributes' => @attributes
                }, options)
      end
    end
  end
end
