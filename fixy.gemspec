lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fixy/version'

Gem::Specification.new do |spec|
  spec.name          = 'fixy'
  spec.version       = Fixy::VERSION
  spec.authors       = ['Gusto']
  spec.email         = ['gusto-opensource-buildkite@gusto.com']
  spec.description   = %q{Library for generating fixed width flat files. Fork of OmarSkalli/fixy.}
  spec.summary       = %q{Provides a DSL for defining, generating, and debugging fixed width documents.}
  spec.homepage      = 'https://github.com/gusto/fixy'
  spec.license       = 'MIT'
  spec.metadata      = {
    'source_code_uri' => 'https://github.com/gusto/fixy',
    'changelog_uri'   => 'https://github.com/gusto/fixy/blob/master/CHANGELOG.md'
  }

  spec.files         = Dir.chdir(__dir__) do
    Dir.glob([
               '*.gemspec',
               'LICENSE.txt',
               'README.md',
               'CHANGELOG.md',
               'lib/**/*'
             ]).select { |f| File.file?(f) }
  end
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry-byebug'

  spec.add_runtime_dependency 'rake'
  spec.add_runtime_dependency 'i18n'
end
