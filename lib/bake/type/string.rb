# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require_relative "any"

module Bake
	module Type
		module String
			extend Type
			
			def self.composite?
				false
			end
			
			def self.parse(input)
				input.to_s
			end
		end
	end
end
