# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2021, by Samuel Williams.

require_relative 'any'

module Bake
	module Types
		class Tuple
			include Type
			
			def initialize(item_types)
				@item_types = item_types
			end
			
			def composite?
				true
			end
			
			def parse(input)
				case input
				when ::String
					return input.split(',').map{|value| @item_type.parse(value)}
				when ::Array
					return input.map{|value| @item_type.parse(value)}
				else
					raise ArgumentError, "Cannot coerce #{input.inspect} into tuple!"
				end
			end
			
			def to_s
				"a Tuple of (#{@item_types.join(', ')})"
			end
		end
		
		def self.Tuple(*item_types)
			Tuple.new(item_types)
		end
	end
end
