
FORMATS = {
	json: ->(file, value){require 'json'; file.puts(JSON.pretty_generate(value))},
	pp: ->(file, value){require 'pp'; PP.pp(value, file)},
	raw: ->(file, value){file.puts(value)},
	yaml: ->(file, value){require 'yaml'; file.puts(YAML.dump(value))},
}

# Dump the last result to the specified file (defaulting to stdout) in the specified format (defaulting to Ruby's pretty print).
# @parameter input [Array(Integer)]
# @parameter file [Output] The input file.
# @parameter format [Symbol] The output format.
def output(input:, file: $stdout, format: :pp)
	format_for(format).call(file, input)
	
	# Allow chaining of output processing:
	return input
end

private

def format_for(name)
	FORMATS[name]
end
