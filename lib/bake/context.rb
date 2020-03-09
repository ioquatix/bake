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
	BAKEFILE = "bake.rb"
	
	class Context
		# If path points to a file, assume it's a `bake.rb` file. Otherwise, recursively search up the directory tree starting from `path` to find the specified bakefile.
		# @return [String, nil] the path to the bakefile if it could be found.
		def self.bakefile_path(path, bakefile: BAKEFILE)
			if File.file?(path)
				return path
			end
			
			current = path
			
			while current
				bakefile_path = File.join(current, BAKEFILE)
				
				if File.exist?(bakefile_path)
					return bakefile_path
				end
				
				parent = File.dirname(current)
				
				if current == parent
					break
				else
					current = parent
				end
			end
			
			return nil
		end
		
		def self.load(path)
			if bakefile_path = self.bakefile_path(path)
				scope = Scope.load(bakefile_path)
				
				working_directory = File.dirname(bakefile_path)
				loaders = Loaders.default(working_directory)
			else
				scope = nil
				
				working_directory = path
				loaders = Loaders.default(working_directory)
			end
			
			return self.new(loaders, scope, working_directory)
		end
		
		def initialize(loaders, scope = nil, root = nil)
			@loaders = loaders
			
			@stack = []
			
			@instances = Hash.new do |hash, key|
				hash[key] = instance_for(key)
			end
			
			@scope = scope
			@root = root
			
			if @scope
				base = Base.derive
				base.prepend(@scope)
				
				@instances[[]] = base.new(self)
			end
			
			@recipes = Hash.new do |hash, key|
				hash[key] = recipe_for(key)
			end
		end
		
		attr :scope
		attr :root
		attr :loaders
		
		def call(*commands)
			last_result = nil
			
			while command = commands.shift
				if recipe = @recipes[command]
					arguments, options = recipe.prepare(commands)
					last_result = recipe.call(*arguments, **options)
				else
					raise ArgumentError, "Could not find recipe for #{command}!"
				end
			end
			
			return last_result
		end
		
		def lookup(command)
			@recipes[command]
		end
		
		def to_s
			if @root
				"#{self.class} #{File.basename(@root)}"
			else
				self.class.name
			end
		end
		
		private
		
		def recipe_for(command)
			path = command.split(":")
			
			if instance = @instances[path]
				return instance.recipe_for(path.last)
			else
				*path, name = *path
				
				if instance = @instances[path]
					return instance.recipe_for(name)
				end
			end
			
			return nil
		end
		
		def instance_for(path)
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
	end
end
