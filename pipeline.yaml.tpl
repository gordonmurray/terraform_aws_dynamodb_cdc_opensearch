version: "2"
dynamodb-pipeline:
  source:
    dynamodb:
      acknowledgments: true
      tables:
        # REQUIRED: Supply the DynamoDB table ARN and whether export or stream processing is needed, or both
        - table_arn: "${dynamodb_stream_arn}"
          # Remove the stream block if only export is needed
          stream:
            start_position: "LATEST"
          # Remove the export block if only stream is needed
          export:
            # REQUIRED for export: Specify the name of an existing S3 bucket for DynamoDB to write export data files to
            s3_bucket: "${s3_bucket_name}"
            # Specify the region of the S3 bucket
            s3_region: "${region}"
            # Optionally set the name of a prefix that DynamoDB export data files are written to in the bucket.
            s3_prefix: "ddb-to-opensearch-export/"
      aws:
        # REQUIRED: Provide the role to assume that has the necessary permissions to DynamoDB, OpenSearch, and S3.
        sts_role_arn: "${iam_role_arn}"
        # Provide the region to use for aws credentials
        region: "${region}"
  sink:
    - opensearch:
        # REQUIRED: Provide an AWS OpenSearch endpoint
        hosts:
          [
            "https://${opensearch_endpoint}",
          ]
        index: "table-index"
        index_type: custom
        document_id: '$${getMetadata("primary_key")}'
        action: '$${getMetadata("opensearch_action")}'
        document_version: '$${getMetadata("document_version")}'
        document_version_type: "external"
        # Setting this to -1 will write documents to OpenSearch immediately. This allows for fast updates, but also increases load. If you can wait for updates, you can set this to a value (in milliseconds) to reduce the ingest load on your OpenSearch domain.
        flush_timeout: -1
        aws:
          # REQUIRED: Provide a Role ARN with access to the domain. This role should have a trust relationship with osis-pipelines.amazonaws.com
          sts_role_arn: "${iam_role_arn}"
          # Provide the region of the domain.
          region: "${region}"
          # Enable the 'serverless' flag if the sink is an Amazon OpenSearch Serverless collection
          serverless: false
          # serverless_options:
          # Specify a name here to create or update network policy for the serverless collection
          # network_policy_name: "network-policy-name"
        # Optional: Enable the S3 DLQ to capture any failed requests in an S3 bucket. Delete this entire block if you don't want a DLQ.. This is recommended as a best practice for all pipelines.
        dlq:
          s3:
            # Provide an S3 bucket
            bucket: "${s3_bucket_name}"
            # Provide a key path prefix for the failed requests
            key_path_prefix: "dynamodb-pipeline/dlq"
            # Provide the region of the bucket.
            region: "${region}"
            # Provide a Role ARN with access to the bucket. This role should have a trust relationship with osis-pipelines.amazonaws.com
            sts_role_arn: "${iam_role_arn}"
