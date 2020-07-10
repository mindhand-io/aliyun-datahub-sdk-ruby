# frozen_string_literal: true

require 'oj'

module Aliyun
  module Datahub
    class Client
      def initialize(opts)
        raise Datahub::ClientError, 'Endpoint must be provided' unless opts[:endpoint]

        @config = Config.new(opts)
        @protocol = Protocol.new(@config)
      end

      ## Projects
      def list_projects
        @protocol.json_request(:get, '/projects')
      end

      def find_project(project_name)
        @protocol.json_request(:get, "/projects/#{project_name}")
      end

      def create_project(project_name, comment = nil)
        comment = project_name if comment.nil?
        result = @protocol.json_request(:post, "/projects/#{project_name}", { Comment: comment })
        find_project(project_name) if result
      end

      def update_project(project_name, comment)
        result = @protocol.json_request(:put, "/projects/#{project_name}", { Comment: comment })
        find_project(project_name) if result
      end

      def destroy_project(project_name)
        @protocol.json_request(:delete, "/projects/#{project_name}")
      end

      ## Topic
      def list_topics(project_name)
        @protocol.json_request(:get, "/projects/#{project_name}/topics")
      end

      def find_topic(project_name, topic_name)
        result = @protocol.json_request(:get, "/projects/#{project_name}/topics/#{topic_name}")
        result['RecordSchema'] = Oj.safe_load(result['RecordSchema'])
        result
      end

      def create_topic(project_name, topic_name, record_schema, record_type, comment, shard_count, lifecycle)
        comment = topic_name if comment.nil?
        result = @protocol.json_request(:post, "/projects/#{project_name}/topics/#{topic_name}",
                                        {
                                          Action: 'create',
                                          ShardCount: shard_count,
                                          Lifecycle: lifecycle,
                                          RecordType: record_type,
                                          RecordSchema: record_schema.to_json,
                                          Comment: comment
                                        })
        find_topic(project_name, topic_name) if result
      end

      def update_topic(project_name, topic_name, comment)
        result = @protocol.json_request(:put, "/projects/#{project_name}/topics/#{topic_name}", { Comment: comment })
        find_topic(project_name, topic_name) if result
      end

      def destroy_topic(project_name, topic_name)
        @protocol.json_request(:delete, "/projects/#{project_name}/topics/#{topic_name}")
      end

      def put_records(project_name, topic_name, record_entities)
        headers = {}
        headers['x-datahub-request-action'] = 'pub'
        body ={
            'Action': 'pub',
            'Records': record_entities
        }
        @protocol.json_request(:post, "/projects/#{project_name}/topics/#{topic_name}/shards", body)
      end

    end
  end
end
