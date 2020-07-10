# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: record.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("record.proto", :syntax => :proto2) do
    add_message "datahub.record.proto.StringPair" do
      required :key, :string, 1
      required :value, :string, 2
    end
    add_message "datahub.record.proto.FieldData" do
      optional :value, :bytes, 1
    end
    add_message "datahub.record.proto.RecordAttributes" do
      repeated :attributes, :message, 1, "datahub.record.proto.StringPair"
    end
    add_message "datahub.record.proto.RecordData" do
      repeated :data, :message, 1, "datahub.record.proto.FieldData"
    end
    add_message "datahub.record.proto.RecordEntry" do
      optional :shard_id, :string, 1
      optional :hash_key, :string, 2
      optional :partition_key, :string, 3
      optional :cursor, :string, 4
      optional :next_cursor, :string, 5
      optional :sequence, :int64, 6
      optional :system_time, :int64, 7
      optional :attributes, :message, 8, "datahub.record.proto.RecordAttributes"
      required :data, :message, 9, "datahub.record.proto.RecordData"
    end
    add_message "datahub.record.proto.PutRecordsRequest" do
      repeated :records, :message, 1, "datahub.record.proto.RecordEntry"
    end
    add_message "datahub.record.proto.FailedRecord" do
      required :index, :int32, 1
      optional :error_code, :string, 2
      optional :error_message, :string, 3
    end
    add_message "datahub.record.proto.PutRecordsResponse" do
      optional :failed_count, :int32, 1
      repeated :failed_records, :message, 2, "datahub.record.proto.FailedRecord"
    end
    add_message "datahub.record.proto.GetRecordsRequest" do
      required :cursor, :string, 1
      optional :limit, :int32, 2, default: 1
    end
    add_message "datahub.record.proto.GetRecordsResponse" do
      required :next_cursor, :string, 1
      required :record_count, :int32, 2
      optional :start_sequence, :int64, 3
      repeated :records, :message, 4, "datahub.record.proto.RecordEntry"
    end
  end
end

module Datahub
  module Record
    module Proto
      StringPair = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("datahub.record.proto.StringPair").msgclass
      FieldData = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("datahub.record.proto.FieldData").msgclass
      RecordAttributes = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("datahub.record.proto.RecordAttributes").msgclass
      RecordData = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("datahub.record.proto.RecordData").msgclass
      RecordEntry = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("datahub.record.proto.RecordEntry").msgclass
      PutRecordsRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("datahub.record.proto.PutRecordsRequest").msgclass
      FailedRecord = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("datahub.record.proto.FailedRecord").msgclass
      PutRecordsResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("datahub.record.proto.PutRecordsResponse").msgclass
      GetRecordsRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("datahub.record.proto.GetRecordsRequest").msgclass
      GetRecordsResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("datahub.record.proto.GetRecordsResponse").msgclass
    end
  end
end