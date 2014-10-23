require 'chef/knife'
require 'chef/knife/s3_base'

class Chef
  class Knife
    class S3List < Chef::Knife::S3Base

      deps do
        require 'fog'
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife s3 list BUCKET [-p <prefix>]"

      attr_reader :bucket

      option :bucket,
          :short  => "-b BUCKET",
          :long   => "--bucket BUCKET",
          :description => "Specify the S3 bucket"

      option :prefix,
          :short  => "-p PREFIX",
          :long   => "--prefix PREFIX",
          :description => "A prefix to search within (path)"

      def run
        $stdout.sync = true

        validate!

        if @name_args.empty?
          if config[:bucket]
            @bucket = config[:bucket]
          else
            ui.error("No bucket specified. Exiting")
            exit 1
          end
        else
          @bucket = @name_args.first
        end

        ui.info("Listing #{@bucket}") unless config[:prefix]
        ui.info("Listing #{@bucket}#{config[:prefix]}") if config[:prefix]

        begin
          if config[:prefix].nil?
            @bucket_list = connection.directories.get(@bucket)
          else
            @bucket_list = connection.directories.get(@bucket, prefix: config[:prefix])
          end

          @bucket_list.files.map do |file|
            puts file.key
          end

        end


      end
    end
  end
end