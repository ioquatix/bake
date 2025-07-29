# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require_relative "any"

module Bake
	module Type
		module Boolean
			extend Type
			
			def self.composite?
				false
			end
			
			def self.parse(input)
				if input =~ /t(rue)?|y(es)?/i
					return true
				elsif input =~ /f(alse)?|n(o)?/i
					return false
				else
					raise ArgumentError, "Cannot coerce #{input.inspect} into boolean!"
				end
			end
		end
	end
end
