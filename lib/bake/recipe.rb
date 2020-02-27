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

module Bake
	class Recipe
		def initialize(scope, name, method = nil)
			@scope = scope
			@name = name
			@command = nil
			@description = nil
			
			@method = method
			@arity = nil
		end
		
		attr :scope
		attr :name
		
		def <=> other
			self.source_location <=> other.source_location
		end
		
		def method
			@method ||= @scope.method(@name)
		end
		
		def source_location
			self.method.source_location
		end
		
		def parameters
			parameters = method.parameters
			
			unless parameters.empty?
				return parameters
			end
		end
		
		def options?
			if parameters = self.parameters
				type, name = self.parameters.last
				
				return type == :keyrest || type == :keyreq || type == :key
			end
		end
		
		def command
			@command ||= compute_command
		end
		
		def to_s
			self.command
		end
		
		def arity
			if @arity.nil?
				@arity = method.parameters.count{|type, name| type == :req}
			end
			
			return @arity
		end
		
		def prepare(arguments)
			offset = 0
			ordered = []
			options = {}
			
			while argument = arguments.first
				name, value = argument.split('=', 2)
				
				if name and value
					# Consume it:
					arguments.shift
					
					options[name.to_sym] = value
				elsif ordered.size < self.arity
					# Consume it:
					ordered << arguments.shift
				else
					break
				end
			end
			
			return ordered, options
		end
		
		def call(*arguments, **options)
			if options?
				@scope.send(@name, *arguments, **options)
			else
				# Ignore options...
				@scope.send(@name, *arguments)
			end
		end
		
		def explain(context, *arguments, **options)
			if options?
				puts "#{self}(#{arguments.join(", ")}, #{options.inspect})"
			else
				puts "#{self}(#{arguments.join(", ")})"
			end
		end
		
		def description
			@description ||= read_description
		end
		
		private
		
		def compute_command
			path = @scope.path
			
			if path.empty?
				@name.to_s
			elsif path.last.to_sym == @name
				path.join(':')
			else
				(path + [@name]).join(':')
			end
		end
		
		def read_description
			file, line_number = self.method.source_location
			
			lines = File.readlines(file)
			line_index = line_number - 1
			
			# Legacy "recipe" syntax:
			if match = lines[line_index].match(/description: "(.*?)"/)
				return [match[1]]
			end
			
			description = []
			line_index -= 1
			
			# Extract comment preceeding method:
			while line = lines[line_index]
				if match = line.match(/^\s*\#\s?(.*?)$/)
					description.unshift(match[1])
				else
					break
				end
				
				line_index -= 1
			end
			
			return description
		end
	end
end
