# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.
# Copyright, 2020, by Olle Jonsson.

require_relative "base"
require_relative "registry"

module Bake
	# The default file name for the top level bakefile.
	BAKEFILE = "bake.rb"
	
	# Represents a context of task execution, containing all relevant state.
	class Context
		# Search upwards from the specified path for a {BAKEFILE}.
		# If path points to a file, assume it's a `bake.rb` file. Otherwise, recursively search up the directory tree starting from `path` to find the specified bakefile.
		# @returns [String | Nil] The path to the bakefile if it could be found.
		def self.bakefile_path(path, bakefile: BAKEFILE)
			if File.file?(path)
				return path
			end
			
			current = path
			
			while current
				bakefile_path = File.join(current, BAKEFILE)
				
				if File.exist?(bakefile_path)
					return bakefile_path
				end
				
				parent = File.dirname(current)
				
				if current == parent
					break
				else
					current = parent
				end
			end
			
			return nil
		end
		
		# Load a context from the specified path.
		# @path [String] A file-system path.
		def self.load(path = Dir.pwd)
			if bakefile_path = self.bakefile_path(path)
				working_directory = File.dirname(bakefile_path)
			else
				working_directory = path
			end
			
			registry = Registry.default(working_directory, bakefile_path)
			context = self.new(registry, working_directory)
			
			context.bakefile
			
			return context
		end
		
		# Initialize the context with the specified registry.
		# @parameter registry [Registry]
		def initialize(registry, root = nil)
			@registry = registry
			@root = root
			
			@instances = Hash.new do |hash, key|
				hash[key] = instance_for(key)
			end
			
			@recipes = Hash.new do |hash, key|
				hash[key] = recipe_for(key)
			end
		end
		
		def bakefile
			@instances[[]]
		end
		
		# The registry which will be used to resolve recipes in this context.
		attr :registry
		
		# The root path of this context.
		# @returns [String | Nil]
		attr :root
		
		# Invoke recipes on the context using command line arguments.
		#
		# e.g. `context.call("gem:release:version:increment", "0,0,1")`
		#
		# @parameter commands [Array(String)]
		def call(*commands)
			last_result = nil
			
			while command = commands.shift
				if recipe = @recipes[command]
					arguments, options = recipe.prepare(commands, last_result)
					last_result = recipe.call(*arguments, **options)
				else
					raise ArgumentError, "Could not find recipe for #{command}!"
				end
			end
			
			return last_result
		end
		
		# Lookup a recipe for the given command name.
		# @parameter command [String] The command name, e.g. `bundler:release`.
		def lookup(command)
			@recipes[command]
		end
		
		alias [] lookup
		
		def to_s
			if @root
				"#{self.class} #{File.basename(@root)}"
			else
				self.class.name
			end
		end
		
		def inspect
			"\#<#{self.class} #{@root}>"
		end
		
		private
		
		def recipe_for(command)
			path = command.split(":")
			
			# If the command is in the form `foo:bar`, we check two cases:
			#
			# (1) We check for an instance at path `foo:bar` and if it responds to `bar`.
			if instance = @instances[path] and instance.respond_to?(path.last)
				return instance.recipe_for(path.last)
			else
				# (2) We check for an instance at path `foo` and if it responds to `bar`.
				*path, name = *path
				
				if instance = @instances[path] and instance.respond_to?(name)
					return instance.recipe_for(name)
				end
			end
			
			return nil
		end
		
		def instance_for(path)
			if base = base_for(path)
				return base.new(self)
			end
		end
		
		# @parameter path [Array(String)] the path for the scope.
		def base_for(path)
			base = nil
			
			# For each loader, we check if it has a scope for the given path. If it does, we prepend it to the base:
			@registry.scopes_for(path) do |scope|
				base ||= Base.derive(path)
				base.prepend(scope)
			end
			
			return base
		end
	end
end
