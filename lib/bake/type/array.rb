# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require_relative "any"

module Bake
	module Type
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
					return input.split(",").map{|value| @item_type.parse(value)}
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
