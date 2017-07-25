# coding: utf-8
 lib = File.expand_path('../lib', __FILE__)
 $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
 require 'bloc_works/version'

 Gem::Specification.new do |spec|
   spec.name          = "bloc_works"
   spec.version       = BlocWorks::VERSION
   spec.authors       = ["Rob"]
   spec.email         = ["rlandows@uci.edu"]
   spec.summary       = %q{Learning Web Framework}
   spec.description   = %q{Rails inspired learning Web Framework}
   spec.homepage      = "https://github.com/Bloc/bloc_works"
   spec.license       = "MIT"

   spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
   spec.bindir        = "exe"
   spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
   spec.require_paths = ["lib"]

   spec.add_development_dependency "bundler", "~> 1.8"
   spec.add_development_dependency "rake", "~> 10.0"
   spec.add_development_dependency 'rack', '~> 2.0', '>= 2.0.3'
   spec.add_development_dependency "rack-test", "~> 0.6.3"
   spec.add_development_dependency 'test-unit', '~> 3.2', '>= 3.2.3'
   spec.add_runtime_dependency "erubis", "~>2.7"
 end
