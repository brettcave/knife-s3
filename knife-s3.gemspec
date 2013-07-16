# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "knife-s3"
  s.version = "0.0.3"
  s.summary = "S3 Support for Knife"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.author = "Brett Cave"
  s.description = "S3 Support for Chef's Knife Command"
  s.email = "brett@cave.za.net"
  s.homepage = 'https://github.com/brettcave/knife-s3'
  s.files = Dir["lib/**/*"]
  s.rubygems_version = "1.6.2"
  s.license = "Apache 2.0"
  s.add_dependency "fog", "~> 1.3"
  s.add_dependency "chef", "~> 11"
end