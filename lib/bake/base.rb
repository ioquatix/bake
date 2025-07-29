# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require_relative "recipe"
require_relative "scope"

module Bake
	# The base class for including {Scope} instances which define {Recipe} instances.
	class Base < Struct.new(:context)
		# Generate a base class for the specified path.
		# @parameter path [Array(String)] The command path.
		def self.derive(path = [])
			klass = Class.new(self)
			
			klass.const_set(:PATH, path)
			
			return klass
		end
		
		# Format the class as a command.
		# @returns [String]
		def self.to_s
			if path = self.path
				path.join(":")
			else
				super
			end
		end
		
		def self.inspect
			if path = self.path
				"Bake::Base<#{path.join(':')}>"
			else
				super
			end
		end
		
		# The path of this derived base class.
		# @returns [Array(String)]
		def self.path
			self.const_get(:PATH)
		rescue
			nil
		end
		
		# The path for this derived base class.
		# @returns [Array(String)]
		def path
			self.class.path
		end
		
		# Proxy a method call using command line arguments through to the {Context} instance.
		# @parameter arguments [Array(String)]
		def call(*arguments)
			self.context.call(*arguments)
		end
		
		# Recipes defined in this scope.
		#
		# @yields {|recipe| ...}
		# 	@parameter recipe [Recipe]
		# @returns [Enumerable]
		def recipes
			return to_enum(:recipes) unless block_given?
			
			names = self.public_methods - Base.public_instance_methods
			
			names.each do |name|
				yield recipe_for(name)
			end
		end
		
		# Look up a recipe with a specific name.
		#
		# @parameter name [String] The instance method to look up.
		def recipe_for(name)
			Recipe.new(self, name)
		end
		
		def to_s
			"\#<#{self.class}>"
		end
	end
end
