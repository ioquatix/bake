# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require_relative "type/any"
require_relative "type/array"
require_relative "type/boolean"
require_relative "type/decimal"
require_relative "type/float"
require_relative "type/hash"
require_relative "type/input"
require_relative "type/integer"
require_relative "type/nil"
require_relative "type/output"
require_relative "type/string"
require_relative "type/symbol"
require_relative "type/tuple"

module Bake
	module Type
		def self.parse(signature)
			eval(signature, binding)
		end
	end
end
