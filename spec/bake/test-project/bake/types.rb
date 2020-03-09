
# @param x [Integer] the number to square.
def square(x)
	x*x
end

# @param numbers [Array(Integer)] the numbers to sum up.
def sum(numbers)
	numbers.sum
end

# @param key [Symbol] the key to lookup.
# @param values [Hash(Symbol, Integer)] the hash of values.
def index(key, values)
	values[key]
end

require 'json'

# @param object [JSON] the object to inspect
def inspect(object)
	object
end

require 'uri'

# @param url [URI] the url to parse
def hostname(url)
	url.hostname
end
