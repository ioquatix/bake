# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require_relative "type"
require_relative "documentation"

module Bake
	# Structured access to arguments.
	class Arguments
		def self.extract(recipe, arguments, **defaults)
			# Only supply defaults that match the recipe option names:
			defaults = defaults.slice(*recipe.required_options)
			
			self.new(recipe, defaults).extract(arguments)
		end
		
		def initialize(recipe, defaults)
			@recipe = recipe
			
			@types = recipe.types
			@parameters = recipe.parameters
			@arity = recipe.arity
			
			@ordered = []
			@options = defaults
		end
		
		attr :ordered
		attr :options
		
		def extract(arguments)
			while argument = arguments.first
				if /^--(?<name>.*)$/ =~ argument
					# Consume the argument:
					arguments.shift
					
					if name.empty?
						break
					end
					
					name = normalize(name)
					
					# Extract the trailing arguments:
					@options[name] = extract_arguments(name, arguments)
				elsif /^(?<name>.*?)=(?<value>.*)$/ =~ argument
					# Consume the argument:
					arguments.shift
					
					name = name.to_sym
					
					# Extract the single argument:
					@options[name] = extract_argument(name, value)
				elsif @ordered.size < @arity
					_, name = @parameters.shift
					value = arguments.shift
					
					# Consume it:
					@ordered << extract_argument(name, value)
				else
					break
				end
			end
			
			return @ordered, @options
		end
		
		private
		
		def normalize(name)
			name.tr("-", "_").to_sym
		end
		
		def delimiter_index(arguments)
			arguments.index{|argument| argument =~ /\A(--|;\z)/}
		end
		
		def extract_arguments(name, arguments)
			value = nil
			type = @types[name]
			
			# Can this named parameter accept more than one input argument?
			if type&.composite?
				if count = delimiter_index(arguments)
					value = arguments.shift(count)
					arguments.shift if arguments.first == ";"
				else
					value = arguments.dup
					arguments.clear
				end
			else
				# Otherwise we just take one item:
				value = arguments.shift
			end
			
			if type
				value = type.parse(value)
			end
			
			return value
		end
		
		def extract_argument(name, value)
			if type = @types[name]
				value = type.parse(value)
			end
			
			return value
		end
	end
end
