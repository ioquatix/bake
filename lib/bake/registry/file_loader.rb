# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require_relative '../scope'

module Bake
	module Registry
		class FileLoader
			def initialize(paths)
				@paths = paths
			end
			
			def to_s
				"#{self.class} #{@paths}"
			end
			
			attr :paths
			
			def each(&block)
				@paths.each_key(&block)
			end
			
			def scopes_for(path)
				if file_path = @paths[path]
					if File.exist?(file_path)
						yield Scope.load(file_path, path)
					end
				end
			end
		end
	end
end