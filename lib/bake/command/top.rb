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
		class Top < Samovar::Command
			self.description = "Execute tasks using Ruby."
			
			options do
				option '-h/--help', 'Show help.'
				option '-b/--bakefile <path>', 'Path to the bakefile to use.', default: Top.bakefile_path
			end
			
			nested :command, {
				'call' => Call,
				'list' => List,
			}, default: 'call'
			
			def terminal(out = $stdout)
				terminal = Console::Terminal.for(out)
				
				terminal[:loader] = terminal.style(nil, nil, :bold)
				terminal[:command] = terminal.style(nil, nil, :bold)
				terminal[:description] = terminal.style(:blue)
				
				terminal[:key] = terminal[:opt] = terminal.style(:green)
				terminal[:req] = terminal.style(:red)
				terminal[:keyreq] = terminal.style(:red, nil, :bold)
				terminal[:keyrest] = terminal.style(:green)
				
				return terminal
			end
			
			def bakefile
				@options[:bakefile]
			end
			
			def working_directory
				if bakefile = self.bakefile
					File.dirname(self.bakefile)
				else
					Dir.pwd
				end
			end
			
			def context
				if bakefile = self.bakefile
					return Context.load(self.bakefile)
				else
					return Context.new
				end
				
				return context
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
