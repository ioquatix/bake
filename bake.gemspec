# frozen_string_literal: true

require_relative "lib/bake/version"

Gem::Specification.new do |spec|
	spec.name = "bake"
	spec.version = Bake::VERSION
	
	spec.summary = "A replacement for rake with a simpler syntax."
	spec.authors = ["Samuel Williams", "Olle Jonsson"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/ioquatix/bake"
	
	spec.metadata = {
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
		"documentation_uri" => "https://ioquatix.github.io/bake/",
	}
	
	spec.files = Dir.glob(['{bake,bin,lib}/**/*', '*.md'], File::FNM_DOTMATCH, base: __dir__)
	
	spec.executables = ["bake"]
	
	spec.required_ruby_version = ">= 3.0"
	
	spec.add_dependency "bigdecimal"
	spec.add_dependency "samovar", "~> 2.1"
end
