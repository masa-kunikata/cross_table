# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cross_table/version'

Gem::Specification.new do |spec|
  spec.name          = 'cross_table'
  spec.version       = CrossTable::VERSION
  spec.authors       = ['masa.kunikata']
  spec.email         = ['masa.kunikata@gmail.com']

  spec.summary       = 'cross tabulation "pivot table" utility'
  spec.homepage      = 'https://github.com/masa-kunikata/cross_table'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.required_ruby_version = '>= 2.5'
end
