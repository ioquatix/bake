# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

module Bake
	# A special scope used for the root `bake.rb` file.
	module BakefileScope
		attr_accessor :wrappers
		
		def wrap(...)
			@wrappers.wrap(...)
		end
	end
end
