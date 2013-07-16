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

      banner "knife s3 list <bucket name>"

      option :bucket_name,
          :short => "-b BUCKET",
          :long => "--bucket BUCKET",
          :description => "Sets bucket name"

      option :prefix,
          :short  => "-p PREFIX",
          :long   => "--prefix PREFIX",
          :description => "A prefix to search within (path)"

      def run
        $stdout.sync = true

        validate!

        if config[:bucket_name]
          puts "Listing bucket " + config[:bucket_name]
        else
          puts "Please supply a bucket name"
          exit 1
        end

        if config[:prefix]
          puts "Filtering by prefix " + config[:prefix]
        end

        begin
          if config[:prefix].nil?
            connection.directories.get(config[:bucket_name]).files.map do |file|
              puts file.key
            end
          else
            connection.directories.get(config[:bucket_name], prefix: config[:prefix]).files.map do |file|
              puts file.key
            end
          end
        end


      end
    end
  end
end