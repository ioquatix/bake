# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative "registry/aggregate"

module Bake
	# Structured access to the working directory and loaded gems for loading bakefiles.
	module Registry
		def self.default(...)
			Aggregate.default(...)
		end
	end
end
