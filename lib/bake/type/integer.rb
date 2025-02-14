# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require_relative "any"

module Bake
	module Type
		module Integer
			extend Type
			
			def self.composite?
				false
			end
			
			def self.parse(input)
				Integer(input)
			end
		end
	end
end
