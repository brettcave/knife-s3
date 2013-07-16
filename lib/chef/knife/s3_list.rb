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

      banner "knife s3 list -b <bucket name> [-p <prefix>]"

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

        if config[:bucket]
          puts "Listing bucket " + config[:bucket]
        else
          puts "No bucket specified"
          exit 1
        end

        if config[:prefix]
          puts "Listing with prefix " + config[:prefix]
        end

        begin
          if config[:prefix].nil?
            connection.directories.get(config[:bucket]).files.map do |file|
              puts file.key
            end
          else
            connection.directories.get(config[:bucket], prefix: config[:prefix]).files.map do |file|
              puts file.key
            end
          end
        end


      end
    end
  end
end