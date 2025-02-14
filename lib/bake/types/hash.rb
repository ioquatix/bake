# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require_relative "any"

module Bake
	module Types
		class Hash
			include Type
			
			def initialize(key_type, value_type)
				@key_type = key_type
				@value_type = value_type
			end
			
			def composite?
				true
			end
			
			def parse(input)
				hash = {}
				
				input.split(",").each do |pair|
					key, value = pair.split(":", 2)
					
					key = @key_type.parse(key)
					value = @value_type.parse(value)
						
					hash[key] = value
				end
				
				return hash
			end
		end
		
		def self.Hash(key_type, value_type)
			Hash.new(key_type, value_type)
		end
	end
end
