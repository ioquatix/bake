# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require 'samovar'
require 'console/terminal'

require_relative 'call'
require_relative 'list'

module Bake
	module Command
		# The top level command line application.
		class Top < Samovar::Command
			self.description = "Execute tasks using Ruby."
			
			options do
				option '-h/--help', 'Show help.'
				option '-b/--bakefile <path>', 'Override the path to the bakefile to use.'
				
				option '-g/--gem <name>', 'Load the specified gem, e.g. "bake ~> 1.0".' do |value|
					gem(*value.split(/\s+/))
				end
			end
			
			nested :command, {
				'call' => Call,
				'list' => List,
			}, default: 'call'
			
			def terminal(output = self.output)
				terminal = Console::Terminal.for(output)
				
				terminal[:context] = terminal[:loader] = terminal.style(nil, nil, :bold)
				terminal[:command] = terminal.style(nil, nil, :bold)
				terminal[:description] = terminal.style(:blue)
				
				terminal[:key] = terminal[:opt] = terminal.style(:green)
				terminal[:req] = terminal.style(:red)
				terminal[:keyreq] = terminal.style(:red, nil, :bold)
				terminal[:keyrest] = terminal.style(:green)
				
				terminal[:parameter] = terminal[:opt]
				
				return terminal
			end
			
			def bakefile_path
				@options[:bakefile] || Dir.pwd
			end
			
			def context
				Context.load(self.bakefile_path)
			end
			
			def call
				if @options[:help]
					self.print_usage
				else
					@command.call
				end
			end
		end
	end
end
