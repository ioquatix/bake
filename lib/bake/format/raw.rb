# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "pp"

module Bake
	module Format
		module Raw
			def self.input(file)
				file
			end
			
			def self.output(file, value)
				PP.pp(value, file)
			end
		end
		
		REGISTRY[:raw] = Raw
	end
end
