# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2021, by Samuel Williams.

# @parameter x [Integer] the number to square.
def square(x)
	x*x
end

# @parameter numbers [Array(Integer)] the numbers to sum up.
def sum(numbers)
	numbers.sum
end

# @parameter key [Symbol] the key to lookup.
# @parameter values [Hash(Symbol, Integer)] the hash of values.
def index(key, values)
	values[key]
end

require 'json'

# @parameter object [JSON] the object to inspect
def inspect(object)
	object
end

require 'uri'

# @parameter url [URI] the url to parse
def hostname(url)
	url.hostname
end
