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

require_relative 'loader'

module Bake
	# Structured access to the working directory and loaded gems for loading bakefiles.
	class Loaders
		include Enumerable
		
		# Create a loader using the specified working directory.
		# @parameter working_directory [String]
		def self.default(working_directory)
			loaders = self.new
			
			loaders.append_defaults(working_directory)
			
			return loaders
		end
		
		# Initialize an empty array of loaders.
		def initialize
			@roots = {}
			@ordered = Array.new
		end
		
		# Whether any loaders are defined.
		# @returns [Boolean]
		def empty?
			@ordered.empty?
		end
		
		# Add loaders according to the current working directory and loaded gems.
		# @parameter working_directory [String]
		def append_defaults(working_directory)
			# Load recipes from working directory:
			self.append_path(working_directory)
			
			# Load recipes from loaded gems:
			self.append_from_gems
		end
		
		# Enumerate the loaders in order.
		def each(&block)
			@ordered.each(&block)
		end
		
		# Append a specific project path to the search path for recipes.
		# The computed path will have `bake` appended to it.
		# @parameter current [String] The path to add.
		def append_path(current = Dir.pwd, **options)
			bake_path = File.join(current, "bake")
			
			if File.directory?(bake_path)
				return insert(bake_path, **options)
			end
			
			return false
		end
		
		# Search from the current working directory until a suitable bakefile is found and add it.
		# @parameter current [String] The path to start searching from.
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
		
		# Enumerate all loaded gems and add them.
		def append_from_gems
			Gem.loaded_specs.each do |name, spec|
				Console.logger.debug(self) {"Checking gem #{name}: #{spec.full_gem_path}..."}
				
				if path = spec.full_gem_path and File.directory?(path)
					append_path(path, name: spec.full_name)
				end
			end
		end
		
		protected
		
		def insert(directory, **options)
			unless @roots.key?(directory)
				Console.logger.debug(self) {"Adding #{directory.inspect}"}
				
				loader = Loader.new(directory, **options)
				@roots[directory] = loader
				@ordered << loader
				
				return true
			end
			
			return false
		end
	end
end
