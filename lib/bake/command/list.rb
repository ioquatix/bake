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

require 'samovar'

module Bake
	module Command
		class List < Samovar::Command
			def format_parameters(parameters, terminal)
				parameters.each do |type, name|
					case type
					when :key
						name = "#{name}="
					when :keyreq
						name = "#{name}="
					when :keyrest
						name = "**options"
					else
						name = name.to_s
					end
					
					terminal.print(type, name, " ")
				end
			end
			
			def format_recipe(recipe, terminal)
				terminal.print(:command, recipe.command)
				
				if parameters = recipe.parameters
					terminal.print(:reset, " ")
					format_parameters(parameters, terminal)
				end
			end
			
			def call
				first = true
				terminal = @parent.terminal
				context = @parent.context
				format_recipe = self.method(:format_recipe).curry
				
				unless context.empty?
					terminal.print_line(:loader, context)
					
					context.each do |recipe|
						terminal.print_line
						terminal.print_line("\t", format_recipe[recipe])
						if description = recipe.description
							terminal.print_line("\t\t", :description, description)
						end
					end
					
					terminal.print_line
				end
				
				context.loaders.each do |loader|
					terminal.print_line unless first
					first = false
					
					terminal.print_line(:loader, loader)
					loader.each do |path|
						if book = loader.lookup(path)
							# terminal.print_line("\t", book)
							book.each do |recipe|
								terminal.print_line
								terminal.print_line("\t", format_recipe[recipe])
								if description = recipe.description
									terminal.print_line("\t\t", :description, description)
								end
							end
						end
					end
					
					terminal.print_line
				end
			end
		end
	end
end
