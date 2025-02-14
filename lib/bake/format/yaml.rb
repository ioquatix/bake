# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "yaml"

module Bake
	module Format
		module YAML
			def self.input(file)
				::YAML.load(file)
			end
			
			def self.output(file, value)
				::YAML.dump(value, file)
			end
		end
		
		REGISTRY[:yaml] = YAML
	end
end
