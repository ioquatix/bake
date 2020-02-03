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

require_relative 'book'

module Bake
	class Loader
		def initialize(root, path = nil, name: nil)
			@root = root
			@path = path
			@name = name
			@cache = {}
		end
		
		def to_s
			"#{self.class} #{@name || @root}"
		end
		
		attr :root
		
		def each
			return to_enum unless block_given?
			
			Dir.glob("**/*.bake", base: @root) do |file_path|
				path = file_path.sub(/\.bake$/, '').split(File::SEPARATOR)
				
				if @path
					yield(@path + path)
				else
					yield(path)
				end
			end
		end
		
		def recipe_for(path)
			if book = lookup(path)
				return book.lookup(path.last)
			else
				*path, name = *path
				
				if book = lookup(path)
					return book.lookup(name)
				end
			end
		end
		
		def lookup(path)
			*directory, file = *path
			
			file_path = File.join(@root, @path || [], directory, "#{file}.bake")
			
			unless @cache.key?(path)
				if File.exist?(file_path)
					book = Book.load(file_path, path)
					
					@cache[path] = book
				else
					@cache[path] = nil
				end
			end
			
			return @cache[path]
		end
	end
end
