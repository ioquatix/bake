# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.

require_relative "../scope"

module Bake
	module Registry
		class BakefileLoader
			def initialize(path)
				@path = path
			end
			
			def to_s
				"#{self.class} #{@path}"
			end
			
			attr :path
			
			def each(&block)
				yield []
			end
			
			def scopes_for(path)
				if path == []
					yield Scope.load(@path, [])
				end
			end
		end
	end
end
