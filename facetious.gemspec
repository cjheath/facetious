# -*- encoding: utf-8 -*-
require "./lib/facetious/version"

Gem::Specification.new do |s|
  s.name = "facetious"
  s.version = Facetious::VERSION::STRING

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.summary = "A faceted search extension for ActiveRecord"
  s.authors = ["Clifford Heath", "Thomas Egret"]
  s.date = "2013-06-17"
  s.description = "Faceted search DSL for ActiveRecord using SQL features"
  s.email = ["clifford.heath@gmail.com", "thomas.egret@gmail.com"]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = %w(License.txt Rakefile README.md) +
    Dir['lib/**/*.rb'] + Dir['spec/**/*.rb']
  s.add_dependency('activerecord', '>= 3.0.0')

  s.homepage = "http://github.com/cjheath/facetious"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
end
