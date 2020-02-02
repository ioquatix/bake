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
	class Loaders
		include Enumerable
		
		def initialize
			@paths = {}
			@ordered = Array.new
		end
		
		def each(&block)
			return to_enum unless block_given?
			
			@ordered.each(&block)
		end
		
		def append(path)
			unless @paths.key?(path)
				loader = Loader.new(path)
				@paths[path] = loader
				@ordered << loader
			end
		end
		
		def append_from_root(current = Dir.pwd)
			while current
				recipes_path = File.join(current, "recipes")
				
				if File.directory?(recipes_path)
					append(recipes_path)
				end
				
				parent = File.dirname(current)
				
				if current == parent
					break
				else
					current = parent
				end
			end
		end
		
		def append_from_paths(paths = $LOAD_PATH)
			paths.each do |path|
				recipes_path = File.join(path, "recipes")
				
				if File.directory?(recipes_path)
					append(recipes_path)
				end
			end
		end
	end
end
