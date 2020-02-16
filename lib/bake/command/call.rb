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
		class Call < Samovar::Command
			self.description = "Execute one or more commands."
			
			def bakefile
				@parent.bakefile
			end
			
			def update_working_directory
				if bakefile = self.bakefile
					current_directory = Dir.pwd
					working_directory = File.dirname(bakefile)
					
					if working_directory != current_directory
						Console.logger.debug(self) {"Changing working directory to #{working_directory.inspect}."}
						Dir.chdir(working_directory)
						
						return current_directory
					end
				end
				
				return nil
			end
			
			many :commands, "The commands & arguments to invoke.", default: ["default"]
			
			def call
				context = @parent.context
				
				self.update_working_directory
				
				context.call(*@commands)
			end
		end
	end
end
