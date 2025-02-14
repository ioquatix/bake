# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "json"

module Bake
	module Format
		module JSON
			def self.input(file)
				::JSON.load(file)
			end
			
			OPTIONS = {indent: "  ", space: " ", space_before: "", object_nl: "\n", array_nl: "\n"}
			
			def self.output(file, value)
				::JSON::State.generate(value, OPTIONS, file)
				file.puts
			end
		end
		
		REGISTRY[:json] = JSON
	end
end
