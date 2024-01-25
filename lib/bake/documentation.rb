# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require_relative 'scope'

module Bake
	# Structured access to a set of comment lines.
	class Documentation
		# Initialize the documentation with an array of comments.
		#
		# @parameter comments [Array(String)] An array of comment lines.
		def initialize(comments)
			@comments = comments
		end
		
		DESCRIPTION = /\A\s*([^@\s].*)?\z/
		
		# The text-only lines of the comment block.
		#
		# @yields {|match| ...}
		# 	@parameter match [MatchData] The regular expression match for each line of documentation.
		# @returns [Enumerable] If no block given.
		def description
			return to_enum(:description) unless block_given?
			
			# We track empty lines and only yield a single empty line when there is another line of text:
			gap = false
			
			@comments.each do |comment|
				if match = comment.match(DESCRIPTION)
					if match[1]
						if gap
							yield ""
							gap = false
						end
						
						yield match[1]
					else
						gap = true
					end
				else
					break
				end
			end
		end
		
		ATTRIBUTE = /\A\s*@(?<name>.*?)\s+(?<value>.*?)\z/
		
		# The attribute lines of the comment block.
		# e.g. `@returns [String]`.
		#
		# @yields {|match| ...}
		# 	@parameter match [MatchData] The regular expression match with `name` and `value` keys.
		# @returns [Enumerable] If no block given.
		def attributes
			return to_enum(:attributes) unless block_given?
			
			@comments.each do |comment|
				if match = comment.match(ATTRIBUTE)
					yield match
				end
			end
		end
		
		PARAMETER = /\A@param(eter)?\s+(?<name>.*?)\s+\[(?<type>.*?)\](\s+(?<details>.*?))?\z/
		
		# The parameter lines of the comment block.
		# e.g. `@parameter value [String] The value.`
		#
		# @yields {|match| ...}
		# 	@parameter match [MatchData] The regular expression match with `name`, `type` and `details` keys.
		# @returns [Enumerable] If no block given.
		def parameters
			return to_enum(:parameters) unless block_given?
			
			@comments.each do |comment|
				if match = comment.match(PARAMETER)
					yield match
				end
			end
		end
	end
end
