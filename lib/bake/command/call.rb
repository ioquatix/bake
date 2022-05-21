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

require_relative '../loaders'
require_relative '../loader'
require_relative '../context'

module Bake
	module Command
		# Execute one or more commands.
		class Call < Samovar::Command
			self.description = "Execute one or more commands."
			
			OUTPUT = {
				json: ->(value){require 'json'; $stdout.puts(JSON.pretty_generate(value))},
				pp: ->(value){require 'pp'; PP.pp(value, $stdout)},
				raw: ->(value){$stdout.puts(value)},
				yaml: ->(value){require 'yaml'; $stdout.puts(YAML.dump(value))},
			}
			
			options do
				option "-o/--output <format>", "Output the result of the last task in the given format: #{OUTPUT.keys.join(", ")}.", type: Symbol
			end
			
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
				
				last_result = context.call(*@commands)
				
				if output = @options[:output]
					format(output, last_result)
				end
			end
		end
	end
end
