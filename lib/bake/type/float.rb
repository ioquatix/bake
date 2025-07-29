# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require_relative "any"

module Bake
	module Type
		module Float
			extend Type
			
			def self.composite?
				false
			end
			
			def self.parse(input)
				input.to_f
			end
		end
	end
end
