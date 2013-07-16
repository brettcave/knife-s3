require 'chef/knife'
require 'chef/knife/s3_base'

class Chef
  class Knife
    class S3Upload < Chef::Knife::S3Base

      deps do
        require 'fog'
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife s3 upload -b <bucket_name> -f <FILE> [-r REMOTE_FILE]"

      option :bucket,
          :short  => "-b BUCKET",
          :long   => "--bucket BUCKET",
          :description => "Specify the S3 bucket"

      option :pathname,
        :short    => "-r REMOTE_FILE",
        :long     => "--remote REMOTE_FILE",
        :description => "Remote path (and filename) to upload to."

      option :localfile,
          :short  => "-f FILE",
          :long   => "--file FILE",
          :description  => "The local file to upload."

      option :is_public,
          :short  => "-p",
          :long   => "--public",
          :description => "If set, then the file will be set with public read access."

      def run
        $stdout.sync = true

        validate!

        public = false

        if config[:bucket].nil?
          puts "No bucket specified"
          exit 1
        end

        if config[:localfile].nil?
          puts "No file specified"
          exit 1
        end

        if !File.exists?(config[:localfile])
          puts "file '" + config[:localfile] + "' does not exist"
          exit 1
        end

        if config[:pathname].nil?
          puts "No remote path specified. Uploading as " + config[:localfile]
          config[:pathname] = config[:localfile]
        end

        if !config[:is_public].nil?
          public = true
        end

        begin
          remote_file = connection.directories.get(config[:bucket]).files.create(
              :key  => config[:pathname],
              :body => File.open(config[:localfile]),
              :public => public
          )
        end

      end
    end
  end
end
