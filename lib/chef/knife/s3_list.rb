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

      def run
        $stdout.sync = true

        validate!

        bucket_name = @name_args[0]
        prefix = @name_args[1]

        if bucket_name.nil?
          puts "Please supply a bucket name"
          exit 1
        end


        begin
          if prefix.nil?
            connection.directories.get(bucket_name).files.map do |file|
              puts file.key
            end
          else
            connection.directories.get(bucket_name, prefix: prefix).files.map do |file|
              puts file.key
            end
          end
        end


      end
    end
  end
end