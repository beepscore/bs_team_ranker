# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bs_team_ranker/version'

Gem::Specification.new do |spec|
  spec.name          = "bs_team_ranker"
  spec.version       = BsTeamRanker::VERSION
  spec.authors       = ["Beepscore LLC"]
  spec.email         = ["support@beepscore.com"]
  spec.description   = %q{Calculates the ranking table for a soccer league.}
  spec.summary       = %q{Calculates the ranking table for a soccer league.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.4.10"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.16.3"

  # http://guides.rubygems.org/specification-reference/
  spec.required_ruby_version = '~> 3.2.2'

end
