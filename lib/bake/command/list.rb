# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require 'samovar'
require 'set'

module Bake
	module Command
		# List all available commands.
		class List < Samovar::Command
			self.description = "List all available commands."
			
			one :pattern, "The pattern to filter tasks by."
			
			def format_parameters(parameters, terminal)
				parameters.each do |type, name|
					case type
					when :key
						name = "#{name}="
					when :keyreq
						name = "#{name}="
					when :keyrest
						name = "**#{name}"
					else
						name = name.to_s
					end
					
					terminal.print(:reset, " ")
					terminal.print(type, name)
				end
			end
			
			def format_recipe(recipe, terminal)
				terminal.print(:command, recipe.command)
				
				if parameters = recipe.parameters
					format_parameters(parameters, terminal)
				end
			end
			
			def print_scope(terminal, scope, printed: false)
				format_recipe = self.method(:format_recipe).curry
				
				scope.recipes.sort.each do |recipe|
					if @pattern and !recipe.command.include?(pattern)
						next
					end
					
					unless printed
						yield
						
						printed = true
					end
					
					terminal.print_line
					terminal.print_line("\t", format_recipe[recipe])
					
					documentation = recipe.documentation
					
					documentation.description do |line|
						terminal.print_line("\t\t", :description, line)
					end
					
					documentation.parameters do |parameter|
						terminal.print_line("\t\t",
							:parameter, parameter[:name], :reset, " [",
							:type, parameter[:type], :reset, "] ",
							:description, parameter[:details]
						)
					end
				end
				
				return printed
			end
			
			def call
				first = true
				terminal = @parent.terminal
				context = @parent.context
				
				context.registry.each do |loader|
					printed = false
					
					loader.each do |path|
						loader.scopes_for(path) do |scope|
							print_scope(terminal, scope, printed: printed) do
								terminal.print_line(:loader, loader)
								printed = true
							end
						end
					end
					
					if printed
						terminal.print_line
					end
				end
			end
		end
	end
end
