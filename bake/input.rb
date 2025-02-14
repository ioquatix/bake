# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2022-2025, by Samuel Williams.

# Parse an input file (defaulting to stdin) in the specified format. The format can be extracted from the file extension if left unspecified.
# @parameter file [Input] The input file.
# @parameter format [Symbol] The input format, e.g. json, yaml.
def input(file: $stdin, format: nil)
	if format = format_for(file, format)
		format.input(file)
	else
		raise "Unable to determine input format of #{file}!"
	end
end

# Parse some input text in the specified format (defaulting to JSON).
# @parameter text [String] The input text.
# @parameter format [Symbol] The input format, e.g. json, yaml.
def parse(text, format: :json)
	file = StringIO.new(text)
	
	if format = format_for(nil, format)
		format.input(file)
	else
		raise "Unable to determine input format!"
	end
end

private

def format_for(file, name)
	if file.respond_to?(:path) and path = file.path
		name ||= file_type(path)
	end
	
	Bake::Format[name]
end

def file_type(path)
	if extension = File.extname(path)
		extension.sub!(/\A\./, "")
		return if extension.empty?
		return extension.to_sym
	end
end
