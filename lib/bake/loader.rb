# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require_relative 'scope'

module Bake
	# Represents a directory which contains bakefiles.
	class Loader
		# Initialize the loader with the specified root path.
		# @parameter root [String] A file-system path.
		def initialize(root, name: nil)
			@root = root
			@name = name
		end
		
		def to_s
			"#{self.class} #{@name || @root}"
		end
		
		# The root path for this loader.
		attr :root
		
		# Enumerate all bakefiles within the loaders root directory.
		# @yields {|path| ...}
		# 	@parameter path [String] The Ruby source file path.
		def each
			return to_enum unless block_given?
			
			Dir.glob("**/*.rb", base: @root) do |file_path|
				yield file_path.sub(/\.rb$/, '').split(File::SEPARATOR)
			end
		end
		
		# Load the {Scope} for the specified relative path within this loader, if it exists.
		# @parameter path [Array(String)] A relative path.
		def scope_for(path)
			*directory, file = *path
			
			file_path = File.join(@root, directory, "#{file}.rb")
			
			if File.exist?(file_path)
				return Scope.load(file_path, path)
			end
		end
	end
end
