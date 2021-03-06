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

require_relative 'any'

module Bake
	module Types
		class Array
			include Type
			
			def initialize(item_type)
				@item_type = item_type
			end
			
			def composite?
				true
			end
			
			def map(values)
				values.map{|value| @item_type.parse(value)}
			end
			
			def parse(input)
				case input
				when ::String
					return input.split(',').map{|value| @item_type.parse(value)}
				when ::Array
					return input.map{|value| @item_type.parse(value)}
				else
					raise ArgumentError, "Cannot coerce #{input.inspect} into array!"
				end
			end
			
			def to_s
				"an Array of #{@item_type}"
			end
		end
		
		def self.Array(item_type = Any)
			Array.new(item_type)
		end
	end
end
