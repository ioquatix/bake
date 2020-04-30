require_relative 'lib/bake/version'

Gem::Specification.new do |spec|
	spec.name = "bake"
	spec.version = Bake::VERSION
	spec.authors = ["Samuel Williams"]
	spec.email = ["samuel.williams@oriontransfer.co.nz"]
	
	spec.summary = "A replacement for rake with a simpler syntax."
	spec.homepage = "https://github.com/ioquatix/bake"
	spec.license = "MIT"
	spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")
	
	spec.metadata["donation_uri"] = "https://github.com/sponsors/ioquatix"
	
	spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
		`git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
	end
	
	spec.bindir = "bin"
	spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.require_paths = ["lib"]
	
	spec.add_dependency 'samovar', '~> 2.1'
	
	spec.add_development_dependency 'bake-bundler'
	
	spec.add_development_dependency 'utopia-wiki'
	spec.add_development_dependency 'covered'
	spec.add_development_dependency 'bundler'
	spec.add_development_dependency 'rspec'
	spec.add_development_dependency 'rake'
end
