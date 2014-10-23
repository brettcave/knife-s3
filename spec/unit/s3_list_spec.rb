require File.expand_path('../../spec_helper', __FILE__)
require 'fog'

describe Chef::Knife::S3List do
  before do
  end

  describe "run" do
    before(:each) do
      {
          :aws_access_key_id => 'aws_access_key_id',
          :aws_secret_access_key => 'aws_secret_access_key'
      }.each do |key,value|
        Chef::Config[:knife][key] = value
      end

      @knife_s3_list = Chef::Knife::S3List.new
      @s3_directories = double()
      @s3_connection = double(Fog::Storage)
      @s3_connection.stub(:directories).and_return(@s3_directories)
      @bucket_list = double({:key => "some_bucket"})
      @knife_s3_list.ui.stub(:info)
    end

    it "should invoke fog api to list bucket contents" do
      @s3_directories.should_receive(:get).with('some_bucket').and_return(@bucket_list)
      Fog::Storage.should_receive(:new).and_return(@s3_connection)
      @knife_s3_list.name_args = ['some_bucket']
      @knife_s3_list.should_receive(:validate!)
      @bucket_list.should_receive(:files).and_return(@s3_directories)
      @s3_directories.should_receive(:map)
      @knife_s3_list.run
    end


    describe "when --prefix is passed" do
      it "should list bucket contents under prefix only" do
        @s3_directories.should_receive(:get).with('some_bucket',{:prefix=>"PREFIX"}).and_return(@bucket_list)
        Fog::Storage.should_receive(:new).and_return(@s3_connection)
        @knife_s3_list.name_args = ['some_bucket']
        @knife_s3_list.should_receive(:validate!)
        @knife_s3_list.config[:prefix] = "PREFIX"
        @bucket_list.should_receive(:files).and_return(@s3_directories)
        @s3_directories.should_receive(:map)
        @knife_s3_list.run
      end
    end

  end
end