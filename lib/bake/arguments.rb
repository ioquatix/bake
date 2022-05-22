# frozen_string_literal: true

# Copyright, 2020, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require_relative 'types'
require_relative 'documentation'

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
			name.tr('-', '_').to_sym
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
					arguments.shift if arguments.first == ';'
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
