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

require_relative 'recipe'

module Bake
	# Used for containing all methods defined in a bakefile.
	module Scope
		# Load the specified file into a unique scope module, which can then be included into a {Base} instance.
		def self.load(file_path, path = [])
			scope = Module.new
			scope.extend(self)
			
			scope.const_set(:FILE_PATH, file_path)
			scope.const_set(:PATH, path)
			
			scope.module_eval(File.read(file_path), file_path)
			
			return scope
		end
		
		def self.inspect
			"Bake::Scope<#{self.const_get(:FILE_PATH)}>"
		end
		
		# Recipes defined in this scope.
		#
		# @yields {|recipe| ...}
		# 	@parameter recipe [Recipe]
		# @returns [Enumerable]
		def recipes
			return to_enum(:recipes) unless block_given?
			
			names = self.instance_methods
			
			names.each do |name|
				yield recipe_for(name)
			end
		end
		
		# The path of the file that was used to {load} this scope.
		def path
			self.const_get(:PATH)
		end
		
		# Look up a recipe with a specific name.
		#
		# @parameter name [String] The instance method to look up.
		def recipe_for(name)
			Recipe.new(self, name, self.instance_method(name))
		end
	end
end
