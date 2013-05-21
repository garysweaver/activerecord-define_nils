# -*- encoding: utf-8 -*-  
$:.push File.expand_path("../lib", __FILE__)  
require "activerecord-define_nils/version" 

Gem::Specification.new do |s|
  s.name        = 'activerecord-define_nils'
  s.version     = ActiveRecordDefineNils::VERSION
  s.authors     = ['Gary S. Weaver']
  s.email       = ['garysweaver@gmail.com']
  s.homepage    = 'https://github.com/FineLinePrototyping/activerecord-define_nils'
  s.summary     = %q{Define nils for ActiveRecord 3.x/4.x.}
  s.description = %q{Allows you to redefine what is translated to nil on read and what is stored instead of nil for specified attributes.}
  s.files = Dir['lib/**/*'] + ['Rakefile', 'README.md']
  s.license = 'MIT'
  s.add_dependency 'activerecord'
end
