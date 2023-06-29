# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2022, by Samuel Williams.

require_relative 'any'

require 'bigdecimal'

module Bake
	module Types
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
