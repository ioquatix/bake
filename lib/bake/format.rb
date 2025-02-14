# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

module Bake
	module Format
		REGISTRY = {}
		
		def self.[](name)
			unless name =~ /\A[a-z_]+\z/
				raise ArgumentError.new("Invalid format name: #{name}")
			end
			
			begin
				require_relative "format/#{name}"
			rescue LoadError
				raise ArgumentError.new("Unknown format: #{name}")
			end
			
			return REGISTRY[name.to_sym]
		end
	end
end