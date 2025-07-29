# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require_relative "any"

module Bake
	module Type
		module Input
			extend Type
			
			def self.composite?
				false
			end
			
			def self.parse(input)
				case input
				when "-"
					return $stdin
				when IO, StringIO
					return input
				else
					File.open(input)
				end
			end
		end
	end
end
