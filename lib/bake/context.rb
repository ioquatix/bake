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

require_relative 'base'

module Bake
	class Context
		def self.load(file_path, loaders = nil)
			scope = Scope.load(file_path)
			
			unless loaders
				if scope.respond_to?(:loaders)
					loaders = scope.loaders
				else
					working_directory = File.dirname(file_path)
					loaders = Loaders.default(working_directory)
				end
			end
			
			self.new(scope, loaders)
		end
		
		def initialize(scope, loaders, **options)
			base = Base.derive
			base.prepend(scope)
			
			@loaders = loaders
			
			@stack = []
			
			@scopes = Hash.new do |hash, key|
				hash[key] = scope_for(key)
			end
			
			@scope = base.new(self)
			@scopes[[]] = @scope
			
			@recipes = Hash.new do |hash, key|
				hash[key] = recipe_for(key)
			end
		end
		
		attr :scope
		attr :loaders
		
		def call(*commands)
			while command = commands.shift
				if recipe = @recipes[command]
					arguments, options = recipe.prepare(commands)
					recipe.call(*arguments, **options)
				else
					raise ArgumentError, "Could not find recipe for #{command}!"
				end
			end
		end
		
		def lookup(command)
			@recipes[command]
		end
		
		private
		
		def recipe_for(command)
			path = command.split(":")
			
			if scope = @scopes[path]
				return scope.recipe_for(path.last)
			else
				*path, name = *path
				
				if scope = @scopes[path]
					return scope.recipe_for(name)
				end
			end
			
			return nil
		end
		
		def scope_for(path)
			if base = base_for(path)
				return base.new(self)
			end
		end
		
		# @param scope [Array<String>] the path for the scope.
		def base_for(path)
			base = nil
			
			@loaders.each do |loader|
				if scope = loader.scope_for(path)
					base ||= Base.derive(path)
					
					base.prepend(scope)
				end
			end
			
			return base
		end
		
		def with!(scope)
			@stack << scope
			
			yield
		ensure
			@scope.pop
		end
	end
end
