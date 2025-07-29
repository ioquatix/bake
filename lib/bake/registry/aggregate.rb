# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require "console"

require_relative "directory_loader"
require_relative "bakefile_loader"

module Bake
	# Structured access to the working directory and loaded gems for loading bakefiles.
	module Registry
		class Aggregate
			include Enumerable
			
			# Create a loader using the specified working directory.
			# @parameter working_directory [String]
			def self.default(working_directory, bakefile_path = nil)
				registry = self.new
				
				if bakefile_path
					registry.append_bakefile(bakefile_path)
				end
				
				registry.append_defaults(working_directory)
				
				return registry
			end
			
			# Initialize an empty array of registry.
			def initialize
				# Used to de-duplicated directories:
				@roots = {}
				
				# The ordered list of loaders:
				@ordered = Array.new
			end
			
			# Whether any registry are defined.
			# @returns [Boolean]
			def empty?
				@ordered.empty?
			end
			
			# Enumerate the registry in order.
			def each(&block)
				@ordered.each(&block)
			end
			
			def scopes_for(path, &block)
				@ordered.each do |registry|
					registry.scopes_for(path, &block)
				end
			end
			
			def append_bakefile(path)
				@ordered << BakefileLoader.new(path)
			end
			
			# Append a specific project path to the search path for recipes.
			# The computed path will have `bake` appended to it.
			# @parameter current [String] The path to add.
			def append_path(current = Dir.pwd, **options)
				bake_path = File.join(current, "bake")
				
				if File.directory?(bake_path)
					return insert(bake_path, **options)
				end
				
				return false
			end
			
			# Add registry according to the current working directory and loaded gems.
			# @parameter working_directory [String]
			def append_defaults(working_directory)
				# Load recipes from working directory:
				self.append_path(working_directory)
				
				# Load recipes from loaded gems:
				self.append_from_gems
			end
			
			# Enumerate all loaded gems and add them.
			def append_from_gems
				::Gem.loaded_specs.each do |name, spec|
					Console.debug(self) {"Checking gem #{name}: #{spec.full_gem_path}..."}
					
					if path = spec.full_gem_path and File.directory?(path)
						append_path(path, name: spec.full_name)
					end
				end
			end
			
			protected
			
			def insert(directory, **options)
				unless @roots.key?(directory)
					Console.debug(self) {"Adding #{directory.inspect}"}
				
					loader = DirectoryLoader.new(directory, **options)
					@roots[directory] = loader
					@ordered << loader
				
					return true
				end
				
				return false
			end
		end
	end
end
