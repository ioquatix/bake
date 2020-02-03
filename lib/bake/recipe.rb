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
		def initialize(book, name, description: nil, &block)
			@book = book
			@name = name
			@description = description
			@block = block
		end
		
		attr :book
		
		def options?
			type, name = @block.parameters.last
			
			return type == :keyrest
		end
		
		def command
			if @book.path.empty?
				@name.to_s
			elsif @book.path.last.to_sym == @name
				@book.to_s
			else
				"#{@book}:#{@name}"
			end
		end
		
		def parameters
			parameters = @block.parameters
			
			unless parameters.empty?
				return parameters
			end
		end
		
		def to_s
			if @description
				"#{self.command} #{@description}"
			else
				self.command
			end
		end
		
		def arity
			@block.arity
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
		
		def call(context, *arguments, **options)
			if options?
				context.instance_exec(*arguments, **options, &@block)
			else
				# Ignore options...
				context.instance_exec(*arguments, &@block)
			end
		end
		
		def explain(context, *arguments, **options)
			if options?
				puts "#{self}(#{arguments.join(", ")}, #{options.inspect})"
			else
				puts "#{self}(#{arguments.join(", ")})"
			end
		end
	end
end
