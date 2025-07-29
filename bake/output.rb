# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2022-2025, by Samuel Williams.

def initialize(...)
	super
	
	require_relative "../lib/bake/format"
end

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

# Do not produce any output.
def null(input:)
	# This is a no-op, used to indicate that no output should be produced.
	return input
end

# This command produces output, and therefore doesn't need default output handling.
def output?(recipe)
	true
end

private

def format_for(file, name)
	if file.respond_to?(:path) and path = file.path
		name ||= file_type(path)
	end
	
	# Default to pretty print:
	name ||= :raw
	
	Bake::Format[name]
end

def file_type(path)
	if extension = File.extname(path)
		extension.sub!(/\A\./, "")
		return if extension.empty?
		return extension.to_sym
	end
end
