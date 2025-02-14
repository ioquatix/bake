# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require_relative "command/top"

module Bake
	# The command line interface.
	module Command
		def self.call(*arguments)
			Top.call(*arguments)
		end
	end
end
