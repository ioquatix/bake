# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require_relative "any"

require "bigdecimal"

module Bake
	module Type
		module Decimal
			extend Type
			
			def self.composite?
				false
			end
			
			def self.parse(input)
				BigDecimal(input)
			end
		end
	end
end
