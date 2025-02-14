# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2022-2024, by Samuel Williams.

# Dump the last result to the specified file (defaulting to stdout) in the specified format (defaulting to Ruby's pretty print).
# @parameter file [Output] The input file.
# @parameter format [Symbol] The output format.
def output(input:, file: $stdout, format: nil)
	if format = format_for(file, format)
		format.output(file, input)
	else
		raise "Unable to determine output format!"
	end
	
	# Allow chaining of output processing:
	return input
end

private

def format_for(file, name)
	if file.respond_to?(:path) and path = file.path
		name ||= file_type(path)
	end
	
	# Default to pretty print:
	name ||= :pp
	
	Bake::Format[name]
end

def file_type(path)
	if extension = File.extname(path)
		extension.sub!(/\A\./, '')
		return if extension.empty?
		return extension.to_sym
	end
end
