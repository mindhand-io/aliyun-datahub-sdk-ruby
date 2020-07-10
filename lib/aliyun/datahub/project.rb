# frozen_string_literal: true

module Aliyun
  module Datahub
    class Project
      def initialize(client, project_name)
        @client = client
        @project_name = project_name
      end

      def list_topics
        @client.list_topics(@project_name)
      end

      def find_topic(topic_name)
        @client.find_topic(@project_name, topic_name)
      end

      def create_topic(topic_name, record_schema, record_type = 'TUPLE', comment = nil, shard_count = 3, lifecycle = 1)
        @client.create_topic(@project_name, topic_name, record_schema, record_type, comment, shard_count, lifecycle)
      end

      def update_topic(topic_name, comment)
        @client.update_topic(@project_name, topic_name, comment)
      end

      def destroy_topic(topic_name)
        @client.destroy_topic(@project_name, topic_name)
      end

      def put_records(topic_name, record_entities)
        @client.put_records(@project_name, topic_name, record_entities)
      end
    end
  end
end
