# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "json"

module Bake
	module Format
		class NDJSON
			def self.input(file)
				new(file)
			end
			
			def self.output(file, value)
				value.each do |item|
					file.puts(JSON.generate(item))
				end
			end
			
			def initialize(file)
				@file = file
			end
			
			attr :file
			
			def each
				return to_enum unless block_given?
				
				@file.each_line do |line|
					yield JSON.parse(line)
				end
			end
		end
		
		REGISTRY[:ndjson] = NDJSON
	end
end
