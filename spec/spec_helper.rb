$:.unshift File.expand_path('../../lib', __FILE__)
require 'chef'
require 'chef/knife/s3_download'
require 'chef/knife/s3_list'
require 'chef/knife/s3_upload'