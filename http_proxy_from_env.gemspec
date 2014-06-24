# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'http_proxy_from_env/version'

Gem::Specification.new do |spec|
  spec.name          = "http_proxy_from_env"
  spec.version       = HttpProxyFromEnv::VERSION
  spec.authors       = ["mechamogera"]
  spec.email         = ["mechamosura@gmail.com"]
  spec.description   = %q{Net::HTTP automatically detects and uses proxies from the environment.}
  spec.summary       = %q{Net::HTTP automatically detects and uses proxies from the environment.}
  spec.homepage      = "https://github.com/mechamogera/http_proxy_from_env"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
