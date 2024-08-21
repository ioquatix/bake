# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require 'samovar'

require_relative '../registry'
require_relative '../context'

module Bake
	module Command
		# Execute one or more commands.
		class Call < Samovar::Command
			self.description = "Execute one or more commands."
			
			def bakefile
				@parent.bakefile
			end
			
			many :commands, "The commands & arguments to invoke.", default: ["default"], stop: false
			
			def format(output, value)
				if formatter = OUTPUT[output]
					formatter.call(value)
				end
			end
			
			def call
				context = @parent.context
				
				context.call(*@commands)
			end
		end
	end
end
