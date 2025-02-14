# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require_relative "any"

module Bake
	module Types
		module Symbol
			extend Type
			
			def self.composite?
				false
			end
			
			def self.parse(input)
				input.to_sym
			end
		end
	end
end
