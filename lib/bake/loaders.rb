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

require 'console'

module Bake
	class Loaders
		include Enumerable
		
		RECIPES_PATH = "recipes"
		
		def initialize
			@roots = {}
			@ordered = Array.new
		end
		
		def empty?
			@ordered.empty?
		end
		
		def append_defaults(working_directory)
			# Load recipes from working directory:
			self.append_path(working_directory)
			
			# Load recipes from loaded gems:
			self.append_from_gems
		end
		
		def each(&block)
			return to_enum unless block_given?
			
			@ordered.each(&block)
		end
		
		def append_path(current = Dir.pwd, recipes_path: RECIPES_PATH, **options)
			recipes_path = File.join(current, recipes_path)
			
			if File.directory?(recipes_path)
				insert(recipes_path, **options)
			end
		end
		
		def append_from_root(current = Dir.pwd, **options)
			while current
				append_path(current, **options)
				
				parent = File.dirname(current)
				
				if current == parent
					break
				else
					current = parent
				end
			end
		end
		
		def append_from_gems
			Gem.loaded_specs.each do |name, spec|
				Console.logger.debug(self) {"Checking gem #{name}: #{spec.full_gem_path}..."}
				
				if path = spec.full_gem_path and File.directory?(path)
					append_path(path, name: spec.full_name)
				end
			end
		end
		
		def append_from_paths(paths, **options)
			paths.each do |path|
				append_path(path, **options)
			end
		end
		
		protected
		
		def insert(directory, **options)
			unless @roots.key?(directory)
				Console.logger.debug(self) do
					if path
						"Adding #{directory.inspect} for #{path.inspect}."
					else
						"Adding #{directory.inspect}"
					end
				end
				
				loader = Loader.new(directory, **options)
				@roots[directory] = loader
				@ordered << loader
				
				return true
			end
			
			return false
		end
	end
end
