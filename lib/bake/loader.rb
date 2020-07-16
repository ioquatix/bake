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

require_relative 'scope'

module Bake
	# Represents a directory which contains bakefiles.
	class Loader
		# Initialize the loader with the specified root path.
		# @parameter root [String] A file-system path.
		def initialize(root, name: nil)
			@root = root
			@name = name
		end
		
		def to_s
			"#{self.class} #{@name || @root}"
		end
		
		# The root path for this loader.
		attr :root
		
		# Enumerate all bakefiles within the loaders root directory.
		# @yields {|path| ...}
		# 	@parameter path [String] The Ruby source file path.
		def each
			return to_enum unless block_given?
			
			Dir.glob("**/*.rb", base: @root) do |file_path|
				yield file_path.sub(/\.rb$/, '').split(File::SEPARATOR)
			end
		end
		
		# Load the {Scope} for the specified relative path within this loader, if it exists.
		# @parameter path [Array(String)] A relative path.
		def scope_for(path)
			*directory, file = *path
			
			file_path = File.join(@root, directory, "#{file}.rb")
			
			if File.exist?(file_path)
				return Scope.load(file_path, path)
			end
		end
	end
end
