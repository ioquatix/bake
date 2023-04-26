# frozen_string_literal: true

# Copyright, 2020, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

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
				
				option '--root <path>', 'Specify the context root working directory.'
			end
			
			nested :command, {
				'call' => Call,
				'list' => List,
			}, default: 'call'
			
			def terminal(out = $stdout)
				terminal = Console::Terminal.for(out)
				
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
				@options[:bakefile] || @options[:root] || Dir.pwd
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
