
FORMATS = {
	json: ->(file){require 'json'; JSON.parse(file.read)},
	yaml: ->(file){require 'yaml'; YAML.load(file.read)},
}

# Parse an input file (defaulting to stdin) in the specified format (defaulting to JSON).
# @parameter file [Input] The input file.
# @parameter format [Symbol] The input format, e.g. json, yaml.
def input(file: $stdin, format: :json)
	format_for(format).call(file)
end

# Parse some input text in the specified format (defaulting to JSON).
# @parameter text [String] The input text.
# @parameter format [Symbol] The input format, e.g. json, yaml.
def parse(text, format: :json)
	file = StringIO.new(text)
	format_for(format).call(file)
end

private

def format_for(name)
	FORMATS[name]
end
