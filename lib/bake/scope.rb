# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require_relative 'recipe'

module Bake
	# Used for containing all methods defined in a bakefile.
	module Scope
		# Load the specified file into a unique scope module, which can then be included into a {Base} instance.
		def self.load(file_path, path = [])
			scope = Module.new
			scope.extend(self)
			
			scope.const_set(:FILE_PATH, file_path)
			scope.const_set(:PATH, path)
			
			scope.module_eval(File.read(file_path), file_path)
			
			return scope
		end
		
		def self.inspect
			"Bake::Scope<#{self.const_get(:FILE_PATH)}>"
		end
		
		# Recipes defined in this scope.
		#
		# @yields {|recipe| ...}
		# 	@parameter recipe [Recipe]
		# @returns [Enumerable]
		def recipes
			return to_enum(:recipes) unless block_given?
			
			names = self.instance_methods
			
			names.each do |name|
				yield recipe_for(name)
			end
		end
		
		# The path of the file that was used to {load} this scope.
		def file_path
			self.const_get(:FILE_PATH)
		end
		
		# The path of the scope, relative to the root of the context.
		def path
			self.const_get(:PATH)
		end
		
		# Look up a recipe with a specific name.
		#
		# @parameter name [String] The instance method to look up.
		def recipe_for(name)
			Recipe.new(self, name, self.instance_method(name))
		end
	end
end
