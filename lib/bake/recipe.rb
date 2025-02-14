# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require_relative "type"
require_relative "arguments"
require_relative "documentation"

module Bake
	# Structured access to an instance method in a bakefile.
	class Recipe
		# Initialize the recipe.
		#
		# @parameter instance [Base] The instance this recipe is attached to.
		# @parameter name [String] The method name.
		# @parameter method [Method | Nil] The method if already known.
		def initialize(instance, name, method = nil)
			@instance = instance
			@name = name
			@command = nil
			@comments = nil
			@types = nil
			@documentation = nil
			
			@method = method
			@arity = nil
		end
		
		# The {Base} instance that this recipe is attached to.
		attr :instance
		
		# The name of this recipe.
		attr :name
		
		# Sort by location in source file.
		def <=> other
			(self.source_location || []) <=> (other.source_location || [])
		end
		
		# The method implementation.
		def method
			@method ||= @instance.method(@name)
		end
		
		# The source location of this recipe.
		def source_location
			self.method.source_location
		end
		
		# The recipe's formal parameters, if any.
		# @returns [Array | Nil]
		def parameters
			parameters = method.parameters
			
			unless parameters.empty?
				return parameters
			end
		end
		
		# Whether this recipe has optional arguments.
		# @returns [Boolean]
		def options?
			if parameters = self.parameters
				type, name = parameters.last
				
				return type == :keyrest || type == :keyreq || type == :key
			end
		end
		
		def required_options
			if parameters = self.parameters
				parameters.map do |(type, name)|
					if type == :keyreq
						name
					end
				end.compact
			end
		end
		
		# The command name for this recipe.
		def command
			@command ||= compute_command
		end
		
		def to_s
			self.command
		end
		
		# The method's arity, the required number of positional arguments.
		def arity
			if @arity.nil?
				@arity = method.parameters.count{|type, name| type == :req}
			end
			
			return @arity
		end
		
		# Process command line arguments into the ordered and optional arguments.
		# @parameter arguments [Array(String)] The command line arguments
		# @returns ordered [Array]
		# @returns options [Hash]
		def prepare(arguments, last_result = nil)
			Arguments.extract(self, arguments, input: last_result)
		end
		
		# Call the recipe with the specified arguments and options.
		def call(*arguments, **options)
			if options?
				@instance.send(@name, *arguments, **options)
			else
				# Ignore options...
				@instance.send(@name, *arguments)
			end
		end
		
		# Any comments associated with the source code which defined the method.
		# @returns [Array(String)] The comment lines.
		def comments
			@comments ||= read_comments
		end
		
		# The documentation object which provides structured access to the {comments}.
		# @returns [Documentation]
		def documentation
			@documentation ||= Documentation.new(self.comments)
		end
		
		# The documented type signature of the recipe.
		# @returns [Array] An array of {Types} instances.
		def types
			@types ||= read_types
		end
		
		private
		
		def parse(name, value, arguments, types)
			if count = arguments.index(";")
				value = arguments.shift(count)
				arguments.shift
			end
			
			if type = types[name]
				value = type.parse(value)
			end
			
			return value
		end
		
		def compute_command
			path = @instance.path
			
			if path.empty?
				@name.to_s
			elsif path.last.to_sym == @name
				path.join(":")
			else
				(path + [@name]).join(":")
			end
		end
		
		COMMENT = /\A\s*\#\s?(.*?)\Z/
		
		def read_comments
			unless source_location = self.method&.source_location
				# Bail early if we don't have a source location (there are some inconsequential cases on JRuby):
				return []
			end
			
			file, line_number = source_location
			
			lines = File.readlines(file)
			line_index = line_number - 1
			
			description = []
			line_index -= 1
			
			# Extract comment preceeding method:
			while line = lines[line_index]
				# \Z matches a trailing newline:
				if match = line.match(COMMENT)
					description.unshift(match[1])
				else
					break
				end
				
				line_index -= 1
			end
			
			return description
		end
		
		def read_types
			types = {}
			
			self.documentation.parameters do |parameter|
				types[parameter[:name].to_sym] = Type.parse(parameter[:type])
			end
			
			return types
		end
	end
end
