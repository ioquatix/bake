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
	class Context < Book
		def initialize(loaders, **options)
			@loaders = loaders
			
			@scope = []
			
			super(**options)
		end
		
		attr :loaders
		
		def call(*commands, describe: false)
			while command = commands.shift
				if recipes = recipes_for(command)
					arguments, options = recipes.first.prepare(commands)
					
					recipes.each do |recipe|
						if describe
							recipe.explain(self, *arguments, **options)
						else
							with(recipe) do
								recipe.call(self, *arguments, **options)
							end
						end
					end
				else
					raise ArgumentError, "Could not find recipe for #{command}!"
				end
			end
		end
		
		private
		
		def with(recipe)
			@scope << recipe.book
			
			yield
		ensure
			@scope.pop
		end
		
		def recipes_for(command)
			if command.is_a?(Symbol)
				recipes_for_relative_reference(command)
			else
				recipes_for_absolute_reference(command)
			end
		end
		
		def recipes_for_relative_reference(command)
			if scope = @scope.last
				if recipe = scope.lookup(command)
					return [recipe]
				end
			end
		end
		
		def recipes_for_absolute_reference(command)
			path = command.split(":")
			
			recipes = []
			
			# Get the root level recipes:
			if recipe = self.recipe_for(path)
				recipes << recipe
			end
			
			@loaders.each do |loader|
				if recipe = loader.recipe_for(path)
					recipes << recipe
				end
			end
			
			if recipes.empty?
				return nil
			else
				return recipes
			end
		end
	end
end
