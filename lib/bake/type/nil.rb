# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require_relative "any"

module Bake
	module Type
		module Nil
			extend Type
			
			def self.composite?
				false
			end
			
			def self.parse(input)
				if input =~ /nil|null/i
					return nil
				else
					raise ArgumentError, "Cannot coerce #{input.inspect} into nil!"
				end
			end
		end
	end
end
