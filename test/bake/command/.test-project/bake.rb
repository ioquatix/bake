# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

def initialize(*)
	super
	@called = false
end

attr :called

# A test method.
#
# A second paragraph.
#
def test_called
	@called = true
end

def a_very_unique_method
end

def test_arguments(x, y)
	x+y
end

def test_options(x:, y:)
	x+y
end

# @parameter x [String] The x value.
# @parameter y [String] The y value.
def test_mixed(x, y: "Y")
	x+y
end

def test_argument_normalized(foo_bar:)
	foo_bar
end

def value
	[1, 2, 3]
end
