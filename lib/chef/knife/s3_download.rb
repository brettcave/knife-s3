require 'chef/knife'
require 'chef/knife/s3_base'

class Chef
  class Knife
    class S3Download < Chef::Knife::S3Base

      deps do
        require 'fog'
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife s3 download -b <bucket_name> -r REMOTE_FILE [-f FILE]"

      option :bucket,
          :short  => "-b BUCKET",
          :long   => "--bucket BUCKET",
          :description => "Specify the S3 bucket"

      option :pathname,
        :short    => "-r REMOTE_FILE",
        :long     => "--remote REMOTE_FILE",
        :description => "Specify the remote path (and filename) to download."

      option :localfile,
          :short  => "-f FILE",
          :long   => "--file FILE",
          :description  => "The local file to write to. Defaults to the remote filename."

      option :overwrite,
          :short  => "-o",
          :long   => "--overwrite",
          :description  => "Forces the local file to be overwritten if it exists."

      def run
        $stdout.sync = true

        validate!

        if config[:bucket].nil?
          puts "No bucket specified"
          exit 1
        end

        if config[:pathname].nil?
          puts "No path specified"
          exit 1
        end

        if config[:localfile].nil?
          config[:localfile] = config[:pathname] #TODO: should strip "directory" elements from the path?
        end

        if File.exists?(config[:localfile]) and config[:overwrite].nil?
          print config[:localfile] + " exists. Overwrite (y/n)? "
          ans=$stdin.gets
          if !ans.match(/^y/i)
            puts "Not overwriting, exiting"
            exit 0
          end
        end

        begin
          remote_file = connection.directories.get(config[:bucket]).files.get(config[:pathname])
          local_file = File.open(config[:localfile],'w')
          local_file.write(remote_file.body)
        end

      end
    end
  end
end
