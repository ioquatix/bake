# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require_relative 'types/any'
require_relative 'types/array'
require_relative 'types/boolean'
require_relative 'types/decimal'
require_relative 'types/float'
require_relative 'types/hash'
require_relative 'types/input'
require_relative 'types/integer'
require_relative 'types/nil'
require_relative 'types/output'
require_relative 'types/string'
require_relative 'types/symbol'
require_relative 'types/tuple'

module Bake
	module Types
		def self.parse(signature)
			eval(signature, binding)
		end
	end
end
