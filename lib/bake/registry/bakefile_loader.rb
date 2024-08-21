# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require_relative '../scope'
require_relative '../bakefile_scope'

module Bake
	module Registry
		class BakefileLoader
			def initialize(path, wrappers)
				@path = path
				@wrappers = wrappers
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
					scope = Scope.load(@path, []) do |scope|
						scope.extend(BakefileScope)
						scope.wrappers = @wrappers
					end
					
					yield scope
				end
			end
		end
	end
end