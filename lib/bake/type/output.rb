# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require_relative "any"

module Bake
	module Type
		module Output
			extend Type
			
			def self.composite?
				false
			end
			
			def self.parse(input)
				case input
				when "-"
					return $stdout
				when IO, StringIO
					return input
				else
					File.open(input, "w")
				end
			end
		end
	end
end
